//@ts-check

const AWS = require('aws-sdk');
const AuthPolicy = require('aws-auth-policy');
const log4js = require('log4js');
const logger = log4js.getLogger();
logger.level = process.env.LOG_LEVEL;
const jwt = require('jsonwebtoken');
const request = require('request');
const jwkToPem = require('jwk-to-pem');
let PEMS = null;
const dynamodb = new AWS.DynamoDB.DocumentClient();

const toPem = (keyDictionary) => {
    return jwkToPem(Object.assign({}, {
        kty: keyDictionary.kty,
        n: keyDictionary.n,
        e: keyDictionary.e
    }));
};

const deny = (awsAccountId, apiOptions) => {
    console.log('Inside deny', awsAccountId, apiOptions);
    let policy = new AuthPolicy('', awsAccountId, apiOptions);
    policy.denyAllMethods();
    let iamPolicy = policy.build();
    return iamPolicy;
};

const getJWKS = async(jwtKeySetURI) => {
    console.time(`AUTHORIZER:getJWKS`);
    return new Promise((resolve, reject) => {
        request({
            url: jwtKeySetURI,
            json: true
        }, (error, response, body) => {
            console.timeEnd(`AUTHORIZER:getJWKS`);
            if (!error && response.statusCode === 200) {
                let pems = {};
                let keys = body['keys'];
                for (let keyIndex = 0; keyIndex < keys.length; keyIndex++) {
                    let kid = keys[keyIndex].kid;
                    pems[kid] = toPem(keys[keyIndex]);
                }
                resolve(pems);
            }
            else {
                logger.info("Failed to retrieve the keys from the well known user-pool URI, ");
                logger.info('Error-Code: ', response.statusCode);
                logger.info(error);
                //resolve(null);
                reject(error);
            }
        });
    });
};

const verifyJWT = async(token, pem, tokenIssuer) => {
    console.time(`AUTHORIZER:verifyJWT`);
    return new Promise(resolve => {
        jwt.verify(token, pem, {
            issuer: tokenIssuer
        }, function(err, payload) {
            console.timeEnd(`AUTHORIZER:verifyJWT`);
            if (err) {
                logger.info("Error while trying to verify the Token, returning deny-all policy", err.message);
                resolve(null);
            }
            resolve(payload);
        });
    });
};

const processAuthRequest = async(payload, awsAccountId, apiOptions) => {
    console.log(payload)
    logger.info('payload', payload);
    if (!payload) {
        console.log("in not payload")
        return deny(awsAccountId, apiOptions);
    }
    else {
        //Valid token. Generate the API Gateway policy for the user
        //Always generate the policy on value of 'sub' claim and not for
        // 'username' because username is reassignable
        //sub is UUID for a user which is never reassigned to another user.
        const pId = payload.sub;
        let policy = new AuthPolicy(pId, awsAccountId, apiOptions);

        // Check the Cognito group entry for permissions.
        // precedence
        console.log(payload['cognito:groups'])
        let UserPoolId = payload.iss.split('/')[3]
        if (payload['cognito:groups']) {
            let user_groups = payload['cognito:groups'];
            console.log(user_groups)
            let tableName = `vap-dani-s-test-role-permission`;
            // GET the cuid from payload
            // if cuid == 'admin' tableName = `${process.env.STAGE}-admin-role-membership`
            // Get all APIs a user can execute
            console.log(tableName)
            let apisResponse = await dynamodb.scan({ TableName: tableName }).promise();
            console.log("api response below")
            console.log('apisResponse---', apisResponse);
            // Get list of all
            for (let ar of apisResponse.Items) {
                console.log("in for loops")
                if (user_groups.includes(ar.role)) {
                    console.log("in user-group")
                    for (let api of ar.apis) {
                        console.log("in api")
                        policy.allowMethod(AuthPolicy.HttpVerb[api.method], api.api);
                    }
                }
            }

        }
        else {
            console.log("in else deny")
            return deny(awsAccountId, apiOptions);
        }
        console.log("outside if else")
        // Get all the config
        let context = {};
        let cognitoIdentityId = ""
        let iamPolicy = policy.build();
        console.log(iamPolicy.policyDocument.Statement)
        let customerTable = `${process.env.CustomersTableName}`
        let customerParams = {
            ProjectionExpression: "Id",
            FilterExpression: "#username = :a",
            ExpressionAttributeNames: {
                "#username": "Username",
            },
            ExpressionAttributeValues: {
                ":a": payload['cognito:username']
           },
            TableName: customerTable
           };

        let customerResponse = await dynamodb.scan(customerParams).promise()
        if (customerResponse.Count == 0){
            console.log("in if block")
            console.log(payload['cognito:username'])
            let customerPreloginParams = {
            ProjectionExpression: "UserId",
            FilterExpression: "#username = :a",
            ExpressionAttributeNames: {
                "#username": "UserId",
            },
            ExpressionAttributeValues: {
                ":a": payload['cognito:username']
            },
            TableName: `${process.env.PreLoginTableName}`
            };
            customerResponse = await dynamodb.scan(customerPreloginParams).promise()
            console.log(customerResponse)
            cognitoIdentityId = customerResponse.Items[0].UserId
        }
        else
        {
            cognitoIdentityId = customerResponse.Items[0].Id
        }
        console.log("outside lambda if")
        console.log(customerResponse)
        // let pool = tokenIssuer.substring(tokenIssuer.lastIndexOf('/') + 1);
        try {
            context.cognitoIdentityId = cognitoIdentityId
            context.Usersub = payload['cognito:username']
            context.UserId = payload['cognito:username']
            context.UserPoolId = UserPoolId
           
        }
        catch (e) {
            logger.error(e);
        }
        console.log(context)

        iamPolicy.context = context;
        console.log(iamPolicy);
        return iamPolicy;
    }
};


exports.handler = async (event, context, callback) => {
    console.log('Inside event', event);
    console.log('Inside context', context);
    
    let apiKey;
    let cognitoGroupName = []
    let decoded
    const tmp = event.methodArn.split(':');
    const apiGatewayArnTmp = tmp[5].split('/');
    const awsAccountId = tmp[4];
    const apiOptions = {
        region: tmp[3],
        restApiId: apiGatewayArnTmp[0],
        stage: apiGatewayArnTmp[1]
    };
    try {
        const token = event.authorizationToken
        decoded = jwt.decode(token, {
            complete: true
        });
        console.log(decoded)
        if (!decoded) {
            logger.info('denied due to decoded error');
            console.log("denied due to decoded error")
            return deny(awsAccountId, apiOptions);
        }
        
    }
    catch (err) {
        logger.error(err);
    }
    // console.log("main deny")
    return await processAuthRequest(decoded.payload, awsAccountId, apiOptions);
    // return deny(awsAccountId, apiOptions);
}
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
    // const { kid } = header;
    // console.log("PAYLOAD")
    // console.log(token)

    // // Reject the jwt if it's not an 'Identity Token'
    // if (token_use != 'id') {
    //     logger.info("Provided Token is not and identity token, returning deny all policy");
    //     return deny(awsAccountId, apiOptions);
    // }

    // //Get the kid from the token and retrieve corresponding PEM
    // let pem = PEMS[kid];
    // console.log(pem)
    // console.log(tokenIssuer)
    
    // if (!pem) {
    //     logger.info("Invalid Identity token, returning deny all policy");
    //     return deny(awsAccountId, apiOptions);
    // }

    // //Verify the signature of the JWT token to ensure it's really coming from your User Pool
    // const payload = await verifyJWT(token, pem, tokenIssuer);
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

        if (payload['cognito:groups']) {
            let user_groups = payload['cognito:groups'];

            let tableName = `vap-dani-s-test-role-permission`;
            // GET the cuid from payload
            // if cuid == 'admin' tableName = `${process.env.STAGE}-admin-role-membership`
            // Get all APIs a user can execute
            let apisResponse = await dynamodb.scan({ TableName: tableName }).promise();
            console.log('apisResponse---', apisResponse);
            // Get list of all
            for (let ar of apisResponse.Items) {
                if (user_groups.includes(ar.role)) {
                    for (let api of ar.apis) {
                        policy.allowMethod(AuthPolicy.HttpVerb[api.method], api.api);
                    }
                }
            }

        }
        else {
            return deny(awsAccountId, apiOptions);
        }

        // Get all the config
        let context = {};

        let iamPolicy = policy.build();

        // let pool = tokenIssuer.substring(tokenIssuer.lastIndexOf('/') + 1);
        // try {

        //     context.pool = pool;
        //     context.user = JSON.stringify(payload);
        // }
        // catch (e) {
        //     logger.error(e);
        // }

        // iamPolicy.context = context;
        console.timeEnd(`AUTHORIZER`);
        return iamPolicy;
    }
};


exports.handler = async (event, context, callback) => {
    console.log('Inside event', event);
    let apiKey;
    let cognitoGroupName = []
    const tmp = event.methodArn.split(':');
    const apiGatewayArnTmp = tmp[5].split('/');
    const awsAccountId = tmp[4];
    const apiOptions = {
        region: tmp[3],
        restApiId: apiGatewayArnTmp[0],
        stage: apiGatewayArnTmp[1]
    };
    try {
        const token = "eyJraWQiOiJzcUxRamthSGlsU2ttTlwvYmI1Qlh1VGZTYzJrdVpQM1NoZWhPYlJ4eGxaVT0iLCJhbGciOiJSUzI1NiJ9.eyJhdF9oYXNoIjoiX2FYRUFoN1J0bVlleVhKN0VtVUtUZyIsInN1YiI6IjBmNGE3ZTU3LTFmMWItNGZjMC1hNGVkLTc1MzgyYTA3YzQwMiIsImNvZ25pdG86Z3JvdXBzIjpbInZhcC1kYW5pLWRldi1yZWdpc3RlcmVkLWdyb3VwIiwidmFwLWRhbmktZGV2LWFkbWluLWdyb3VwIl0sImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJjb2duaXRvOnByZWZlcnJlZF9yb2xlIjoiYXJuOmF3czppYW06OjQ4OTk5NDA5NjcyMjpyb2xlXC92YXAtZGFuaS1kZXYtQ29nbml0b0FkbWluUm9sZS1yb2xlIiwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMi5hbWF6b25hd3MuY29tXC91cy1lYXN0LTJfWG43WUptTHZVIiwiY29nbml0bzp1c2VybmFtZSI6IjBmNGE3ZTU3LTFmMWItNGZjMC1hNGVkLTc1MzgyYTA3YzQwMiIsImNvZ25pdG86cm9sZXMiOlsiYXJuOmF3czppYW06OjQ4OTk5NDA5NjcyMjpyb2xlXC92YXAtZGFuaS1kZXYtQ29nbml0b1JlZ2lzdGVyZWRSb2xlLXJvbGUiLCJhcm46YXdzOmlhbTo6NDg5OTk0MDk2NzIyOnJvbGVcL3ZhcC1kYW5pLWRldi1Db2duaXRvQWRtaW5Sb2xlLXJvbGUiXSwiYXVkIjoiN2JzZTVxaG5lZmlmajBjNXA5bGk3b3F1N2oiLCJldmVudF9pZCI6ImUxYmM5N2E2LTBhYjEtNDE5ZC1hNzU0LTkwNmNhNWY2YzY0MSIsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNjQwMjExMDQ0LCJleHAiOjE2NDAyMTQ2NDQsImlhdCI6MTY0MDIxMTA0NCwianRpIjoiMmFlZDIxZWYtY2FjYS00ZDY0LWEyMjEtMzQ4Nzg5YTkwY2U4IiwiZW1haWwiOiJkYW5peWFsQGV1cnVzdGVjaG5vbG9naWVzLmNvbSJ9.LxHbq2sBX3oRHf8sTF7Hpq8HMBaWwpysuuAp0UulqHknUJTyEo1gxrXa2Ut57Aw9EDH2saD-gXprQ0mAKbHUccUSWsiZZX3ktiCVEE-J8VQFWSoeT58kORUaXv9h9h4sUpIojidRbcgmw3sQIJJN2fU6efyA3U-oXaIMT8TtvzBJ6FjbWqFuptUlHT0KzfT61dW155KeZuTuZEn3T_duJuMrftX93itmiuGTKGhtbR_5xHp8opJt0aHRFwQ9sphijBBOtN6Pc_cj9MEYLDXoBXbaV-i1sjiipWStDHO062IEJvf3633mHme5ScJtq1JEHfpaKcf9QyCC-hzFOc82jQ" ;
        console.log(token)
        const decoded = jwt.decode(token, {
            complete: true
        });
        console.log(decoded)
        if (!decoded) {
            logger.info('denied due to decoded error');
            return deny(awsAccountId, apiOptions);
        }
        return await processAuthRequest(decoded.payload, awsAccountId, apiOptions);
    }
    catch (err) {
        logger.error(err);
    }
    console.timeEnd(`AUTHORIZER`);
    return deny(awsAccountId, apiOptions);
}
 
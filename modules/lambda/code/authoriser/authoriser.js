//@ts-check

const AWS = require('aws-sdk');
const AuthPolicy = require('aws-auth-policy');

const log4js = require('log4js');
const logger = log4js.getLogger();
logger.level = process.env.LOG_LEVEL;
const dynamodb = new AWS.DynamoDB.DocumentClient();
const apigateway = new AWS.APIGateway()
const cognito = new AWS.CognitoIdentityServiceProvider()
const {
    getEnv
} = require('dev-portal-common/get-env')


const deny = (awsAccountId, apiOptions) => {
    logger.info('Inside deny', awsAccountId, apiOptions);
    let policy = new AuthPolicy('', awsAccountId, apiOptions);
    policy.denyAllMethods();
    let iamPolicy = policy.build();
    return iamPolicy;
};


exports.handler = async (event, context, callback) => {
    console.log('Inside event', event);
    let apiKey

    const tmp = event.methodArn.split(':');
    const apiGatewayArnTmp = tmp[5].split('/');
    const awsAccountId = tmp[4];
    const apiOptions = {
        region: tmp[3],
        restApiId: apiGatewayArnTmp[0],
        stage: apiGatewayArnTmp[1]
    };

    let apiId = event.requestContext.identity.apiKeyId
    let userPoolId = getEnv("UserPoolId")
    let api_date

    let current_date = new Date();
    try {
        apiKey = await apigateway.getApiKey({
            apiKey: apiId
        }).promise()
    } catch (err) {
        return deny(awsAccountId, apiOptions);
    }

    let userId = apiKey.name.split("/")[0]
    let tableName = `${process.env.CustomersTableName}`;
    let apisResponse = await dynamodb.query({
        TableName: tableName,
        KeyConditionExpression: "Id = :id",
        ExpressionAttributeValues: {
            ":id": userId
        }
    }).promise();
    if (apisResponse.Items.length <= 0) {
        console.log(apisResponse)
        return deny(awsAccountId, apiOptions);
    }

    let username = apisResponse.Items[0].UserPoolId
    
    let cognitoResponse = await cognito.adminGetUser({
        UserPoolId: userPoolId,
        Username: username
    })
    if ('lastUpdatedDate' in apiKey) {
        api_date = apiKey.lastUpdatedDate
    } else {
        api_date = apiKey.createdDate
    }
    
    let ApiDate = new Date(api_date)
    ApiDate.setDate(ApiDate.getDate() + apisResponse.Items[0].ApiKeyDuration);
    let timeDiff = Math.abs(ApiDate.getTime() - current_date.getTime());
    let diffDays = Math.floor(timeDiff / (1000 * 3600 * 24));
    
    if (diffDays <= 0)
        return deny(awsAccountId, apiOptions);
    else {
        var authPolicy = new AuthPolicy(`${awsAccountId}`, awsAccountId, apiOptions);
        authPolicy.allowMethod(AuthPolicy.HttpVerb.ALL, "/*");
        var generated = authPolicy.build();

        return generated
    }
};
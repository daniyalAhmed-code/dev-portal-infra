//@ts-check

const AWS = require('aws-sdk');
const AuthPolicy = require('aws-auth-policy');
const { v4: uuidv4 } = require('uuid');

const log4js = require('log4js');
const logger = log4js.getLogger();
logger.level = process.env.LOG_LEVEL;
const dynamodb = new AWS.DynamoDB.DocumentClient();
const apigateway = new AWS.APIGateway();
const cognito = new AWS.CognitoIdentityServiceProvider();
const {
    getEnv
} = require('dev-portal-common/get-env');


const deny = (awsAccountId, apiOptions) => {
    console.log('Inside deny', awsAccountId, apiOptions);
    let policy = new AuthPolicy('', awsAccountId, apiOptions);
    policy.denyAllMethods();
    let iamPolicy = policy.build();
    return iamPolicy;
};


exports.handler = async (event, context, callback) => {
    console.log('Inside event', event);
    let apiKey;

    const tmp = event.methodArn.split(':');
    const apiGatewayArnTmp = tmp[5].split('/');
    const awsAccountId = tmp[4];
    const apiOptions = {
        region: tmp[3],
        restApiId: apiGatewayArnTmp[0],
        stage: apiGatewayArnTmp[1]
    };

    console.log(apiOptions);
    
    let apiId = event.requestContext.identity.apiKeyId;
    let userPoolId = getEnv("UserPoolId");
    let api_date;

    let current_date = new Date();
    try {
        apiKey = await apigateway.getApiKey({
            apiKey: apiId
        }).promise();
    } catch (err) {
        console.log(err);
        return deny(awsAccountId, apiOptions);
    }

    let userId = apiKey.name.split("/")[0];
    let tableName = `${process.env.CustomersTableName}`;
    let apisResponse = await dynamodb.query({
        TableName: tableName,
        KeyConditionExpression: "Id = :id",
        ExpressionAttributeValues: {
            ":id": userId
        }
    }).promise();
    
    console.log(apisResponse);
    
    if (apisResponse.Count <= 0)
        return deny(awsAccountId, apiOptions);

    let username = apisResponse.Items[0].Username;
    let email    = apisResponse.Items[0].EmailAddress;
    let mnoLocation = apisResponse.Items[0].MnoLocation;
    let mno = apisResponse.Items[0].Mno;
    
    let cognitoResponse = await cognito.adminGetUser({
        UserPoolId: userPoolId,
        Username: username
    });
    
    
    console.log(cognitoResponse);
    await saveApiDetails(event,username,email,mno,mnoLocation)
    if (!apisResponse.Items[0].hasOwnProperty("ApiKeyDuration")) {
        console.log("ApiKeyDuration not present");
        return generate_api_gateway_response(awsAccountId, apiOptions, username, userId);
    }
    
    console.log("ApiKeyDuration present");
    
    if ('lastUpdatedDate' in apiKey) {
        api_date = apiKey.lastUpdatedDate;
    } else {
        api_date = apiKey.createdDate;
    }
    let ApiDate = new Date(api_date);
    ApiDate.setDate(ApiDate.getDate() + apisResponse.Items[0].ApiKeyDuration);
    
    if (ApiDate > current_date) {
        return generate_api_gateway_response(awsAccountId, apiOptions, username, userId);
    }
    else
        return deny(awsAccountId, apiOptions);
};


function generate_api_gateway_response(awsAccountId, apiOptions, username, userId) {
    var authPolicy = new AuthPolicy(`${awsAccountId}`, awsAccountId, apiOptions);
    authPolicy.allowMethod(AuthPolicy.HttpVerb.ALL, "/*");
    
    var generated = authPolicy.build();
    generated["context"] = {
        "cognito_username": username,
        "user_id": userId
    };
    
    return generated;
}



async function saveApiDetails(event,username,email,mno,mnoLocation){
    console.log("in save api details")
    let request_id = uuidv4();
    let data = {}
    data['RequestType'] = event.requestContext.httpMethod
    
    if(!event.hasOwnProperty("headers")) 
      data['Headers'] = {}
    else  
      data['Headers'] = event.headers
    
    if(!event.hasOwnProperty("multiValueHeaders"))
      data['MultiValueHeaders'] = {}
    else
      data['MultiValueHeaders'] = event.multiValueHeaders
  
    if(!event.hasOwnProperty("queryStringParameters"))
      data['QueryStringParameters'] = {}  
    else   
      data['QueryStringParameters'] = event.queryStringParameters
    
    if(!event.hasOwnProperty("body"))
      data["Body"] = {}
    else
      data['Body'] = event.body
  
    if(!event.hasOwnProperty("path"))
      data['ApiPath'] = {}  
    else
      data['ApiPath'] = event.path
    
    data['UserName'] = username
    data['EmailAddress'] = email
    data['Mno'] = mno
    data['MnoLocation'] = mnoLocation
    let request_time = process.hrtime()
    let item = {
      RequestId: request_id,
      Username_RequestTime: data['UserName']+"_"+request_time[0]+"_"+request_time[1]
    };
    const params = {
      TableName: process.env.CustomerRequestLogTable,
      Item: Object.assign(item, data)
    };
    let respData = await dynamodb.put(params).promise();
    console.log(respData)
}
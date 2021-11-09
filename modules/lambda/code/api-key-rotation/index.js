const AWS = require('aws-sdk')
const dynamodb = new AWS.DynamoDB.DocumentClient();
const lambda = new AWS.Lambda();
const customersController = require('dev-portal-common/customers-controller')

async function invokeLambda(payload) {
    const cognitoIdentityId = payload.Id
    const data = await new Promise((resolve, reject) => {
    customersController.getApiKeyForCustomer(cognitoIdentityId, reject, resolve)
  })
    payload['api_data'] = data.items[0]
    const params = {
        FunctionName: process.env.InvokeLambdaFunction,
        InvocationType: 'Event',
        Payload: JSON.stringify(payload)
    };

    return new Promise((resolve, reject) => {

        lambda.invoke(params, (err,data) => {
            if (err) {
                console.log(err, err.stack);
                reject(err);
            }
            else {
                console.log(data);
                resolve(data);
            }
        });     
    });
}


exports.handler = async (event, context) => {
    let table_name = process.env.CustomersTableName
    let params = {
        TableName: table_name
      };
    let response = await dynamodb.scan(params).promise()
    for (let item of response.Items)
    {
        await invokeLambda(item);
    }
    context.done();
}; 

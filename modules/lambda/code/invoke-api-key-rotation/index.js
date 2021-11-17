const customersController = require('dev-portal-common/customers-controller')


exports.handler = async (event) => {
    console.log(event)
    let api_date
    let identityId = event.Id
    let userId     = event.UserPoolId
    let apiKeyVal = event.api_data.id
    let current_date = new Date()
    
    if ('lastUpdatedDate' in event.api_data) {
        api_date = event.api_data.lastUpdatedDate;
    } else {
        api_date = event.api_data.createdDate;
    }
    
    let ApiDate = new Date(api_date);
    ApiDate.setDate(ApiDate.getDate() + event.ApiKeyDuration);

    if (ApiDate < current_date && event.KeyRotation) {
        await customersController.deletePreviousApiKey(apiKeyVal)
        await customersController.renewApiKey(identityId, userId, true)
    }
    
    const response = {
        statusCode: 200,
        body: JSON.stringify(event),
    };
    return response;
}; 
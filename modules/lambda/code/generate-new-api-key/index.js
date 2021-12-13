'use strict'

const customersController = require('dev-portal-common/customers-controller')

class GenerateNewApiKey extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        console.log(event)
        let userPoolId = process.env.UserPoolId
        let userId = req.params.userId
        let user = await customersController.getAccountDetails(userId)
        let newApi = null
        if (user == null)
        {
            return res.status(404).json({
            message: "Account does not exists"
            })
        }
        const data = await new Promise((resolve, reject) => {customersController.getApiKeyForCustomer(userId, reject, resolve) });

        let apiKeyVal = data.items[0].id
        // Remove previous allocations of userId
        let usagePlanId = await new Promise((resolve, reject) => {customersController.getUsagePlansForCustomer(userId, reject, resolve) });

        if(usagePlanId.items.hasOwnProperty("id")) {
            usagePlanId = usagePlanId.items[0].id
            await new Promise((resolve, reject) => {customersController.unsubscribe(userId, usagePlanId, reject, resolve)})
            await customersController.deletePreviousApiKey(apiKeyVal)
            newApi = await customersController.renewApiKey(userId, userPoolId, true)
            await new Promise((resolve, reject) => { customersController.subscribe(userId, usagePlanId, reject, resolve) })
        }
        else {
            
            console.log("in unsubscribed user call")
            await customersController.deletePreviousApiKey(apiKeyVal)
            newApi = await customersController.renewApiKey(userId, userPoolId, true)
        }
        
        return res.status(200).json({
            "user_api_details" :{
            "id":newApi.id,
            "name":newApi.name,
            "enabled":newApi.enabled
            }
        })
        }
}

exports.generateNewApiKey = async(event, context, callback) => {
    return await new GenerateNewApiKey().handler(event, context, callback);
};
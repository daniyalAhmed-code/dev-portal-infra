'use strict'

const util = require('../util')
const customersController = require('dev-portal-common/customers-controller')

class GetSubscription extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        const cognitoIdentityId = util.getCognitoIdentityId(event)
        console.log(`GET /subscriptions for Cognito ID: ${cognitoIdentityId}`)
      
        const data = await new Promise((resolve, reject) => {
          customersController.getUsagePlansForCustomer(cognitoIdentityId, reject, resolve)
        })
      
        res.status(200).json(data.items)
      
}
}
exports.getsubscription = async(event, context, callback) => {
    return await new GetSubscription().handler(event, context, callback);
};


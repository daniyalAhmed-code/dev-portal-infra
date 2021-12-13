'use strict'

const util = require('../util')
const customersController = require('dev-portal-common/customers-controller')

class DeleteSubscription extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        const cognitoIdentityId = util.getCognitoIdentityId(event)
        console.log(`DELETE /subscriptions for Cognito ID: ${cognitoIdentityId}`)
        const usagePlanId = req.params.usagePlanId
      
        const catalog = await util.catalog()
        const usagePlan = util.getUsagePlanFromCatalog(usagePlanId, catalog)
      
        if (!usagePlan || !usagePlan.apis.length) {
          res.status(404).json({ error: 'Invalid Usage Plan ID' })
        } else {
          const data = await new Promise((resolve, reject) => {
            customersController.unsubscribe(cognitoIdentityId, usagePlanId, reject, resolve)
          })
          res.status(200).json(data)
        }
      }
    }      
exports.deletesubscription = async(event, context, callback) => {
    return await new DeleteSubscription().handler(event, context, callback);
};


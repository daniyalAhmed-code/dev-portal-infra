'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('../util')

class ApiKey extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        const cognitoIdentityId = util.getCognitoIdentityId(event)
        console.log(`GET /apikey for Cognito ID: ${cognitoIdentityId}`)
        
        const data = await new Promise((resolve, reject) => {
            customersController.getApiKeyForCustomer(cognitoIdentityId, reject, resolve)
          })
          if (data.items.length === 0) {
            res.status(404).json({ error: 'No API Key for customer' })
          } else {
            const item = data.items[0]
            const key = {
              id: item.id,
              value: item.value
            }
            res.status(200).json(key)
          }
        }
    }   
exports.apikey = async(event, context, callback) => {
    return await new ApiKey().handler(event, context, callback);
};

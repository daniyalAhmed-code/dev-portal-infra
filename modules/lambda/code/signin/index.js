'use strict'

const customersController = require('dev-portal-common/customers-controller')
const { promisify2 } = require('dev-portal-common/promisify2')
const util = require('../util')
// this returns the key we use in the CustomersTable. It's constructed from the issuer field and the username when we
// allow multiple identity providers, this will allow google's example@example.com to be distinguishable from
// Cognito's or Facebook's example@example.com
// function getCognitoKey (req) {
//   return req.apiGateway.event.requestContext.authorizer.claims.iss + ' ' + getCognitoUsername(req)
// }

class Signin extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        const cognitoIdentityId = util.getCognitoIdentityId(event)
        const cognitoUserId = util.getCognitoUserId(event)
        console.log(`POST /signin for identity ID [${cognitoIdentityId}]`)
        try {
            await promisify2(customersController.ensureCustomerItem)(
                cognitoIdentityId,
                cognitoUserId,
                'NO_API_KEY'
              )
              await customersController.ensureApiKeyForCustomer({
                userId: cognitoUserId,
                identityId: cognitoIdentityId
              })
        }
        catch (error) {
            console.log(`error: ${error}`)
            res.status(500).json(error)
            return
          }
          res.status(200).json({})

    }    

}
exports.signin = async(event, context, callback) => {
    return await new Signin().handler(event, context, callback);
};

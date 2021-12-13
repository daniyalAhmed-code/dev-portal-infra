'use strict'

const customersController = require('dev-portal-common/customers-controller')

class GetAccountById extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        console.log('GET /admin/accounts/:userId')
        let user = await customersController.getAccountDetails(event.requestContext.identity.cognitoIdentityId)
        if (user == null)
        {
            return res.status(404).json({
            message: "Account does not exists"
            })
        }
        return res.status(200).json({
            "user_details" :user
        })
        }
}

exports.getAccountById = async(event, context, callback) => {
    return await new GetAccountById().handler(event, context, callback);
};
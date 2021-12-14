'use strict'

const customersController = require('dev-portal-common/customers-controller')

class GetAccountById extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        console.log(event)
        console.log('GET /admin/accounts/callbackauth/:userId')
        let userId = req.params.userId
        let user_details = await customersController.getAccountDetails(userId)
    
        if (user_details == null) {
            return res.status(404).json({
            message: "Account doesnot Exists"
            })
        }
        let secret_details = await customersController.getSecretDetails(user_details.CallBackAuthARN)
        return res.status(200).json({
            "secret_details" :secret_details
        })
      } 
}

exports.getAccountById = async(event, context, callback) => {
    return await new GetAccountById().handler(event, context, callback);
};
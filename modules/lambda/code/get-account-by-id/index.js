'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('../../util')
const Joi = require('joi');
const AWS = require('aws-sdk')

class GetAccountById extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
      console.log('GET /admin/accounts/:userId')
      let userId = req.params.userId
      let user_details = await customersController.getAccountDetails(userId)
  
      if (user_details == null) {
          return res.status(404).json({
          message: "Account doesnot Exists"
          })
      }
      return res.status(200).json({
          "user_details" :user_details
      })
    }
}

exports.getAccountById = async(event, context, callback) => {
    return await new GetAccountById().handler(event, context, callback);
};
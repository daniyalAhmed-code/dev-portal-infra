'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('../../util')
const Joi = require('joi');
exports.get = async (req, res) => {
    console.log('GET /admin/accounts/users')
    let userId = req.params.userId
    let user_details = await customersController.getAccountDetails(userId)
    
    if (user_details == null) {
        return res.status(404).json({
        message: "Account doesnot Exists"
        })
    }
    secret_arn = user_details.CallBackAuthARN
    let secret_details = await customersController.getSecretDetails(secret_arn)
    return res.status(200).json({
        "secret_details" :secret_details
    })
   
  }
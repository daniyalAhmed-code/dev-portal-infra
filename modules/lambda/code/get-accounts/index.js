'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('../../util')
const Joi = require('joi');
const AWS = require('aws-sdk')

class GetAccounts extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
      console.log('GET /admin/accounts')

      let accounts
    
      switch (req.query.filter) {
        // Not implemented yet
        // case 'pendingRequest': accounts = await customersController.listPendingRequestAccounts(); break
        case 'pendingInvite':
          accounts = await customersController.listPendingInviteAccounts();
          break
        case 'admin':
          accounts = await customersController.listAdminAccounts();
          break
        case 'registered':
          accounts = await customersController.listRegisteredAccounts();
          break
        default:
          res.status(400).json({
            message: 'Invalid value for "filter" query parameter.'
          })
          return
      }
    
      res.status(200).json({
        accounts
      })
    }   
}

exports.getAccounts = async(event, context, callback) => {
    return await new GetAccounts().handler(event, context, callback);
};
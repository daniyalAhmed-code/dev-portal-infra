//@ts-check
'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('../../util')
const Joi = require('joi');

class DeleteAccount extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
      console.log('DELETE /admin/accounts/:userId')

  const userId = event.params.userId
  if (typeof userId !== 'string' || userId === '') {
    return {
      "status":400,
      message: 'Invalid value for "userId" URL parameter.'
    }
  }

  if (util.getCognitoUserId(event) === userId) {
    return {
      "status":400,
      message: 'Invalid value for "userId" URL parameter: cannot delete yourself.'
    }
    }

  await customersController.deleteAccountByUserId(userId)
  return {
    "status":200
  }

}
}

exports.deleteAccount = async(event, context, callback) => {
    return await new DeleteAccount().handler(event, context, callback);
};
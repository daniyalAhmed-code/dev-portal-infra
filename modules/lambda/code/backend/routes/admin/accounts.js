//@ts-check
'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('../../util')
const Joi = require('joi');

exports.get = async (req, res) => {
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

exports.post = async (req, res) => {
  const schema = Joi.object().keys({
    targetFirstName: Joi.string().regex(/^(?=.{3,50}$)[a-zA-Z]+(?:['_.\s][a-z]+)*$/).required().messages({
      'string.base': `"first name" should be a type of 'text'`,
      'string.empty': `"first name" cannot be an empty field`,
      'string.pattern.base': "first name cannot have space in between",
      'string.min': `"first name" should have a minimum length of 3`,
      'any.required': `"first name" is a required field`
    }),

    targetLastName: Joi.string().regex(/^(?=.{1,50}$)[a-zA-Z]+(?:['_.\s][a-z]+)*$/).required().messages({
      'string.base': `"last name" should be a type of 'text'`,
      'string.empty': `"last name" cannot be an empty field`,
      'string.min': `"last name" should have a minimum length of 3`,
      'string.pattern.base': "last name cannot have space in between",
      'any.required': `"last name" is a required field`
    }),

    targetPhoneNumber: Joi.string().regex(/^[\+]?[0-9]{3}[0-9]{3}[-\s\.]?[0-9]{4,6}$/).required().messages({
      'string.base': `"phone number" should be a type of 'text'`,
      'string.empty': `"phone number" cannot be an empty field`,
      'string.min': `"phone number" should have a minimum length of 9`,
      'string.pattern.base': "valid patterns are (123) 456-7890,(123)456-7890,123-456-7890,123.456.7890,1234567890,+31636363634,075-63546725",
      'any.required': `"phone number" is a required field`
    }),

    targetMfa: Joi.boolean().required(),
    targetCallBackUrl: Joi.string().required().messages({
      'string.empty': `"callback url" cannot be an empty field`
    }),
    type: Joi.string().valid("apiKey","basicAuth","privateCertificate"),
    targetCallBackAuth: Joi.when('type', {is : "apiKey", then: Joi.string().required()})
    .when('type', {is : "basicAuth", then: Joi.object().keys({username:Joi.string().required(),password:Joi.string().required()})})
    .when('type', {is : "privateCertificate", then: Joi.string().required()}),
    targetMno: Joi.string().required().valid('Vodafone', "One_Telecomunications", "Orange", "Telefónia"),
    targetMnoLocation: Joi.string().required().valid('Ireland', "Czech_Republic", "Greece", "Hungary", "Italy", "Portugal", "Romania", "Spain", "United_Kingdom"),
    targetApiKeyDuration: Joi.number().min(1).max(90).required().messages({
      'number.min': `"api duration key" cannot be less than 1`,
      'number.max': "api key duration cannot be greater than 90",
    }),
    targetEmailAddress: Joi.string().email().required().messages({
      'string.empty': `"email" cannot be an empty field`
    })
  });


  const inviterUserId = util.getCognitoIdentityId(req)
  console.log(`POST /admin/accounts for Cognito ID: ${inviterUserId}`)

  console.log(JSON.stringify(req.apiGateway.event, null, 2))

  const {
    type,
    targetEmailAddress,
    targetPhoneNumber,
    targetFirstName,
    targetLastName,
    targetApiKeyDuration,
    targetMnoLocation,
    targetCallBackAuth,
    targetMno,
    targetMfa,
    targetCallBackUrl
  } = req.body
  let body = await schema.validate(req.body);
  console.log(body.error)

  if ('error' in body) {
    res.status(400).json({
      message: body.error.detupdateAccountDetailsails[0].message
    })
    return
  }

  if (typeof targetEmailAddress !== 'string' || targetEmailAddress === '') {
    res.status(400).json({
      message: 'Invalid value for "targetEmailAddress" parameter.'
    })
    return
  }

  const preLoginAccount = await customersController.createAccountInvite({
    type,
    targetEmailAddress,
    targetPhoneNumber,
    targetFirstName,
    targetLastName,
    targetApiKeyDuration,
    targetMnoLocation,
    targetCallBackAuth,
    targetMno,
    targetMfa,
    targetCallBackUrl,
    inviterUserSub: util.getCognitoIdentitySub(req),
    inviterUserId
  })
  res.status(200).json(preLoginAccount)
}


exports.put = async (req, res) => {
  const schema = Joi.object().keys({
    FirstName: Joi.string().regex(/^(?=.{3,50}$)[a-zA-Z]+(?:['_.\s][a-z]+)*$/).required().messages({
      'string.base': `"first name" should be a type of 'text'`,
      'string.empty': `"first name" cannot be an empty field`,
      'string.pattern.base': "first name cannot have space in between",
      'string.min': `"first name" should have a minimum length of 3`,
      'any.required': `"first name" is a required field`
    }),

    LastName: Joi.string().regex(/^(?=.{1,50}$)[a-zA-Z]+(?:['_.\s][a-z]+)*$/).required().messages({
      'string.base': `"last name" should be a type of 'text'`,
      'string.empty': `"last name" cannot be an empty field`,
      'string.min': `"last name" should have a minimum length of 3`,
      'string.pattern.base': "last name cannot have space in between",
      'any.required': `"last name" is a required field`
    }),
    Type: Joi.string().valid("apiKey","basicAuth","privateCertificate"),
    Mfa: Joi.boolean().required(),
    CallBackUrl: Joi.string().required().messages({
      'string.empty': `"callback url" cannot be an empty field`
    }),
    isValidateCallBackAuth:Joi.boolean().default(true),
    CallBackAuth: Joi.when('Type', {is : "apiKey", then: Joi.string().required()})
    .when('Type', {is : "basicAuth", then: Joi.object().keys({username:Joi.string().required(),password:Joi.string().required()})})
    .when('Type', {is : "privateCertificate", then: Joi.string().required()})
    .when("isValidateCallBackAuth", {is : false, then: Joi.string().optional()}),

    Mno: Joi.string().required().valid('Vodafone', "One Telecomunications", "Orange", "Telefónia"),
    MnoLocation: Joi.string().required().valid('Ireland', "Czech Republic", "Greece", "Hungary", "Italy", "Portugal", "Romania", "Spain", "United Kingdom"),
    ApiKeyDuration: Joi.number().min(1).max(90).required().messages({
      'number.min': `"api duration key" cannot be less than 1`,
      'number.max': "api key duration cannot be greater than 90",
    })
  });

  let userId = req.params.userId
  if (typeof userId !== 'string' || userId === '') {
    res.status(400).json({
      message: 'Invalid value for "userId" URL parameter.'
    })
    return
  }
  let data = await customersController.getAccountDetails(userId)
  if (data == null) {
    return res.status(404).json({
      message: "Account doesnot Exists"
    })
  }

  if (!req.body.CallBackAuth) {
    req.body.isValidateCallBackAuth = false
    req.body.CallBackAuth = "NONE"
  }
  
  let body = await schema.validate(req.body);
  if ('error' in body) {
    res.status(400).json({
      message: body.error.details[0].message
    })
    return
  }

  body = Object.assign(data, body.value)

  const updateAccount = await customersController.updateAccountDetails(
    userId,
    data.CallBackAuthARN,
    body

  )
  res.status(200).json(updateAccount)
}


exports.delete = async (req, res) => {
  console.log('DELETE /admin/accounts/:userId')

  const userId = req.params.userId
  if (typeof userId !== 'string' || userId === '') {
    res.status(400).json({
      message: 'Invalid value for "userId" URL parameter.'
    })
    return
  }

  if (util.getCognitoUserId(req) === userId) {
    res.status(400).json({
      message: 'Invalid value for "userId" URL parameter: cannot delete yourself.'
    })
    return
  }

  await customersController.deleteAccountByUserId(userId)
  res.status(200).json({})
}
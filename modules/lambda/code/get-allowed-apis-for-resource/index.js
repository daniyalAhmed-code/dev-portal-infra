//@ts-check
'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('dev-portal-common/util')
const Joi = require('joi');
const rh   =  require('dev-portal-common/responsehandler')

exports.handler = async (req, res) => {

      let listAllResourceType = await customersController.getAllResourceDetails()
      console.log(listAllResourceType)
      return rh.callbackRespondWithJsonBody(200,listAllResourceType)
    }   

//@ts-check
'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('dev-portal-common/util')
const Joi = require('joi');
const rh   =  require('dev-portal-common/responsehandler')

exports.handler = async (req, res) => {
   
    if(typeof req.body == "string")
    req['body'] = JSON.parse(req.body)
    let ResourceId = req.pathParameters.ResourceId
   
    const UsagePlanPermission = await customersController.getAllowedApisForResource(
    ResourceId,
    )
    return rh.callbackRespondWithJsonBody(200,UsagePlanPermission)
}   

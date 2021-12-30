//@ts-check
'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('dev-portal-common/util')
const Joi = require('joi');
const rh   =  require('dev-portal-common/responsehandler')

exports.handler = async (req, res) => {
    console.log(JSON.stringify(req, null, 2))
    
    if(typeof req.pathParameters == "string")
        req['pathParameters'] = JSON.parse(req.pathParameters)
    let ResourceId = req.pathParameters.ResourceId
    let UsagePlanPermission = await customersController.getAllowedApisForResource(
        ResourceId,
        )
    
    if (UsagePlanPermission == null)
        return rh.callbackRespondWithError(404,"No allowed apis for this resource")
    
    let DeleteAllowedApis = await customersController.deleteAllowedApisForResource(ResourceId)
    return rh.callbackRespondWithJsonBody(200,DeleteAllowedApis)
}   

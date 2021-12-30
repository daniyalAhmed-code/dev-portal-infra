//@ts-check
'use strict'

const customersController = require('dev-portal-common/customers-controller')
const util = require('dev-portal-common/util')
const Joi = require('joi');
const rh   =  require('dev-portal-common/responsehandler')

exports.handler = async (req, res) => {

    const schema = Joi.object().keys({
    ResourceType: Joi.string().valid("Mno","ThirdParty"),
    ResourceId : Joi.string().required(),
    ApiId: Joi.array().items(Joi.string().required())
    });


    console.log(JSON.stringify(req, null, 2))
    
    if(typeof req.body == "string")
    req['body'] = JSON.parse(req.body)

    const {
    ResourceType,    
    ResourceId,
    ApiId
    } = req.body
    let body = await schema.validate(req.body);

    const UsagePlanPermission = await customersController.createPermissionToAccessApis(
    ResourceType,    
    ResourceId,
    ApiId)
    return rh.callbackRespondWithJsonBody(200,UsagePlanPermission)
}   

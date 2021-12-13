'use strict'

const hash = require('object-hash')
const { getAllUsagePlans } = require('dev-portal-common/get-all-usage-plans')
const util = require('../../../util')
const nodeUtil = require('util')

const inspect = o => JSON.stringify(o, null, 2)

// Let's try to minimize how many calls we make here.
const MAX_REST_API_LIMIT = 500



class UpdateCatalog extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
    console.log(`POST /admin/catalog/visibility for Cognito ID: ${util.getCognitoIdentityId(event)}`)
  
    // for apigateway managed APIs, provide "apiId_stageName"
    // in the apiKey field
    if (event.body && event.body.apiKey) {
      // try {
      const [restApiId, stageName] = event.body.apiKey.split('_')
      const swagger = await util.apigateway.getExport({
        restApiId,
        stageName,
        exportType: 'swagger',
        parameters: {
          extensions: 'apigateway'
        }
      }).promise()
  
      console.log('swagger: ', swagger.body)
      console.log('subscribable: ', event.body.subscribable)
  
      let file
      if (event.body.subscribable === 'true' || event.body.subscribable === true) {
        file = `catalog/${restApiId}_${stageName}.json`
      } else if (event.body.subscribable === 'false' || event.body.subscribable === false) {
        file = `catalog/unsubscribable_${restApiId}_${stageName}.json`
      } else {
        res.status(400).json({ message: 'Invalid input. Request body must have the `subscribable` key.' })
        return
      }
  
      await uploadFile(file, swagger.body)
  
      res.status(200).json({ message: 'Success' })
      // }
  
      // for generic swagger, just provide the swagger body
    } else if (event.body && event.body.swagger) {
      let swaggerObject
      try {
        swaggerObject = JSON.parse(event.body.swagger)
        if (!(swaggerObject.info && swaggerObject.info.title)) {
          res.status(400).json({ message: 'Invalid input. API specification file must have a title.' })
          return
        }
      } catch (error) {
        res.status(400).json({ message: `Invalid input. ${error.message}` })
        return
      }
  
      await uploadFile(`catalog/${hash(swaggerObject)}.json`, Buffer.from(event.body.swagger))
  
      res.status(200).json({ message: 'Success' })
    } else {
      res.status(400).json({ message: 'Invalid input' })
    }
  }
}


exports.UpdateCatalog = async(event, context, callback) => {
    return await new UpdateCatalog().handler(event, context, callback);
};

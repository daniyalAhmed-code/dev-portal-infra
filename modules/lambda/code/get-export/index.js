'use strict'

const util = require('../../util')

class GetExport extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
      console.log(`GET /catalog/${req.params.id}/export for Cognito ID: ${util.getCognitoIdentityId(event)}`)

      // note that we only return an SDK if the API is in the catalog
      // this is important because the lambda function has permission to fetch any API's SDK
      // we don't want to leak customer API shapes if they have privileged APIs not in the catalog
      const [restApiId, stageName] = event.params.id.split('_')
      const catalogObject = util.findApiInCatalog(restApiId, stageName, await util.catalog())
    
      if (!catalogObject) {
        res.status(404).json({ message: `API with ID (${restApiId}) and Stage (${stageName}) could not be found.` })
      } else if (!catalogObject.sdkGeneration) {
        res.status(403).json({ message: `API with ID (${restApiId}) and Stage (${stageName}) is not enabled for API export generation.` })
      } else {
        let { exportType, parameters } = event.query
        if (typeof parameters === 'string') {
          try { parameters = JSON.parse(parameters) } catch (e) {
            return res.status(400).json({ message: `Input parameters for API with ID (${restApiId}) and Stage (${stageName}) were a string, but not parsable JSON: ${parameters}` })
          }
        }

        const result = await util.apigateway.getExport({
          restApiId, exportType, stageName, parameters
        }).promise()
    
        res.status(200).type(parameters.accept).send(result.body)
      }
    }
}

exports.getExport = async(event, context, callback) => {
    return await new GetExport().handler(event, context, callback);
};
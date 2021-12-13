'use strict'

const util = require('../../../util')

class DeleteGenericApiFromCatalog extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
      console.log(`DELETE /admin/catalog/visibility for Cognito ID: ${util.getCognitoIdentityId(event)}`)

      // for apigateway managed APIs, provide "apiId_stageName"
      // in the apiKey field
      console.log('delete request params:', req.params)
      if (req.params && req.params.id) {
        if (!req.params.id.includes('_')) {
          res.status(400).json({ message: 'Invalid input' })
          return
        }
    
        console.log('managed api')
    
        // We assume it's JSON - users shouldn't be modifying this directly. However, we can't assume
        // it's still unsubscribable as if the API is attached to a usage plan, that ends up out of
        // sync with our catalog. In this case, we just try to delete both, as it's easier and faster
        // than checking whether it *is* subscribable.
        await deleteFile(`catalog/unsubscribable_${req.params.id}.json`)
        await deleteFile(`catalog/${req.params.id}.json`)
        res.status(200).json({ message: 'Success' })
    
        // for generic swagger, provide the hashed swagger body
        // in the id field
      } else if (req.params && req.params.genericId) {
        console.log('generic api')
        await deleteFile(`catalog/${req.params.genericId}.json`)
        res.status(200).json({ message: 'Success' })
      } else {
        res.status(400).json({ message: 'Invalid input' })
      }
    }
  }    

exports.deleteApiFromCatalog = async(event, context, callback) => {
    return await new DeleteGenericApiFromCatalog().handler(event, context, callback);
};

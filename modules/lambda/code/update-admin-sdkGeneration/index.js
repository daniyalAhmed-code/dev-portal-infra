'use strict'

const util = require('../../../util')




class UpdateAdminSDKGeneration extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
      console.log(`PUT /admin/catalog/${req.params.id}/sdkGeneration for Cognito ID: ${util.getCognitoIdentityId(req)}`)

      await exports.idempotentSdkGenerationUpdate(true, req.params.id, res)
          res.status(200).json({ message: 'Success' })
  }
}


exports.updateAdminSDKGeneration = async(event, context, callback) => {
    return await new UpdateAdminSDKGeneration().handler(event, context, callback);
};

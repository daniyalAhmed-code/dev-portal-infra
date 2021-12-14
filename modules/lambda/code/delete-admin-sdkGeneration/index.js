'use strict'

const util = require('../../../util')


exports.idempotentSdkGenerationUpdate = async (parity, id, res) => {
  const sdkGeneration =
    JSON.parse((await util.s3.getObject({
      Bucket: process.env.StaticBucketName,
      Key: 'sdkGeneration.json'
    }).promise()).Body)

  if (sdkGeneration[id] !== parity) {
    sdkGeneration[id] = parity

    await util.s3.upload({
      Bucket: process.env.StaticBucketName,
      Key: 'sdkGeneration.json',
      Body: JSON.stringify(sdkGeneration)
    }).promise()

    // call catalogUpdater to build a fresh catalog.json that includes changes from sdkGeneration.json
    await util.lambda.invoke({
      FunctionName: process.env.CatalogUpdaterFunctionArn,
      // this API would be more performant if we moved to 'Event' invocations, but then we couldn't signal to
      // admins when the catalog updater failed to update the catalog; they'd see a 200 and then no change in
      // behavior.
      InvocationType: 'RequestResponse',
      LogType: 'None'
    }).promise()

    res.status(200).json({ message: 'Success' })
  } else {
    res.status(200).json({ message: 'Success' })
  }
}




class DeleteAdminSDKGeneration extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
      console.log(`DELETE /admin/catalog/${req.params.id}/sdkGeneration for Cognito ID: ${util.getCognitoIdentityId(event)}`)

      await exports.idempotentSdkGenerationUpdate(false, req.params.id, res)
          res.status(200).json({ message: 'Success' })
  }
}


exports.deleteAdminSDKGeneration = async(event, context, callback) => {
    return await new DeleteAdminSDKGeneration().handler(event, context, callback);
};

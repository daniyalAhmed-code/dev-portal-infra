'use strict'

const customersController = require('dev-portal-common/customers-controller')
const AWS = require('aws-sdk')
const S3 = new AWS.S3();

class GetProfileImage extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        let userId = event.params.userId
        console.log("FILES")
        console.log(event.files)
        console.log(event.files.file.data)
        let data = await customersController.getAccountDetails(userId)
        if (data == null) {
          return res.status(404).json({
            message: "Account doesnot Exists"
          })
        }
      
        let ext = req.files.file.name.split('.')[1]
        console.log(req.files.file)
        
        let path =  `ProfilePicture/${userId}.`+ext
        
        const params = {
          Bucket: process.env.WEBSITE_BUCKET_NAME,
          Key: `ProfilePicture/${userId}.`+ext, // File name you want to save as in S3
          Body: event.files.file.data,
          ContentType: event.files.file.mimetype
      };
      let body = Object.assign(data, {"ProfilePicture":path} )
      console.log(body)
      await customersController.updateProfileImageLocation(
        userId,
        body
      )
      
        S3.upload(params, function(err, data) {
          if (err) {
              throw err;
          }
          res.send({
              "response_code": 200,
              "response_message": "Success",
              "response_data": data
          });
        });
}
}

exports.getProfileImage = async(event, context, callback) => {
    return await new GetProfileImage().handler(event, context, callback);
};
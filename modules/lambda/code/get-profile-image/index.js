'use strict'

const customersController = require('dev-portal-common/customers-controller')

class GetProfileImage extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        let userId = event.params.userId
        let _userdata = await customersController.getAccountDetails(userId)
        if (_userdata == null) {
            return res.status(404).json({
            message: "Account doesnot Exists"
            })
        }
        let profilePath = _userdata.Items[0].ProfilePath

        var params = {
            Bucket: process.env.WEBSITE_BUCKET_NAME,
            Key: profilePath
        };
        
        let data =  S3.getObject(params, (err, rest) => {
            if (err) throw err;

            const b64 = Buffer.from(rest.Body).toString('base64');
            // CHANGE THIS IF THE IMAGE YOU ARE WORKING WITH IS .jpg OR WHATEVER
            const mimeType = 'image/png'; // e.g., image/png
            
            res.send(`<img src="data:${mimeType};base64,${b64}" />`);
        });

        }
}

exports.getProfileImage = async(event, context, callback) => {
    return await new GetProfileImage().handler(event, context, callback);
};
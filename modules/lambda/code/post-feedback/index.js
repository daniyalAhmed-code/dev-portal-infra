'use strict'

const feedbackController = require('dev-portal-common/feedback-controller')
const util = require('../util')
const feedbackEnabled = !!process.env.FeedbackSnsTopicArn

class AddCustomerFeedback extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        const cognitoIdentityId = util.getCognitoIdentityId(event)
        console.log(`POST /feedback for Cognito ID: ${cognitoIdentityId}`)
        
        if (!feedbackEnabled) {
          res.status(401).json('Customer feedback not enabled')
        } else {
          await feedbackController.submitFeedback(cognitoIdentityId, req.body.message)
          res.status(200).json('success')
        }
}
}

exports.addCustomerFeedback = async(event, context, callback) => {
    return await new AddCustomerFeedback().handler(event, context, callback);
};


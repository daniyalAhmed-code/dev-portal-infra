'use strict'

const feedbackController = require('dev-portal-common/feedback-controller')
const util = require('../util')
const feedbackEnabled = !!process.env.FeedbackSnsTopicArn

class GetCustomerFeedback extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        console.log(`GET /feedback for Cognito ID: ${util.getCognitoIdentityId(event)}`)

        if (!feedbackEnabled) {
          res.status(401).json('Customer feedback not enabled')
        } else {
          const feedback = await feedbackController.fetchFeedback()
          res.status(200).json(feedback)
        }
    }
}
exports.getCustomerFeedback = async(event, context, callback) => {
    return await new GetCustomerFeedback().handler(event, context, callback);
};

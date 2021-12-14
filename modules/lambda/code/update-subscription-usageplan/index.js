'use strict'

const util = require('../util')
const customersController = require('dev-portal-common/customers-controller')

class UpdateSubscription extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        const cognitoIdentityId = util.getCognitoIdentityId(event)
        console.log(`PUT /subscriptions for Cognito ID: ${cognitoIdentityId}`)
        const usagePlanId = req.params.usagePlanId

        const catalog = await util.catalog()
        const catalogUsagePlan = util.getUsagePlanFromCatalog(usagePlanId, catalog)
        // const apiGatewayUsagePlan = await apigateway.getUsagePlan({ usagePlanId }).promise()
        console.log(`catalogUsagePlan: ${JSON.stringify(catalogUsagePlan, null, 2)}`)

        // the usage plan doesn't exist
        if (!catalogUsagePlan) {
            res.status(404).json({ error: 'Invalid Usage Plan ID' })
            // the usage plan exists, but 0 of its apis are visible
        } else if (!catalogUsagePlan.apis.length) {
            res.status(404).json({ error: 'Invalid Usage Plan ID' })
            // allow subscription if (the usage plan exists, at least 1 of its apis are visible)
        } else {
            const data = await new Promise((resolve, reject) => {
            customersController.subscribe(cognitoIdentityId, usagePlanId, reject, resolve)
            })
            res.status(201).json(data)
        }
        }
}
exports.subscription = async(event, context, callback) => {
    return await new UpdateSubscription().handler(event, context, callback);
};


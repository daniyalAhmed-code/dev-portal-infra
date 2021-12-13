'use strict'

const util = require('../util')

class Catalog extends BaseHandler {
    constructor() {
        super();
    }
    async process(event, context, callback) {
        console.log(`GET /catalog for Cognito ID: ${util.getCognitoIdentityId(event)}`)
        const catalog = await util.catalog()
        res.status(200).json(catalog)
      }
}
exports.catalog = async(event, context, callback) => {
    return await new Catalog().handler(event, context, callback);
};


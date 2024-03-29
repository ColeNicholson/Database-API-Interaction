const chpConnection = require('../database/CHPConnection');

class CaseController {
    constructor() {
	console.log('Case Controller Initialized');
    }

    // Return all users
    async cases(ctx) {
	console.log('Controller HIT: CaseController::cases');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM case_;';
	    chpConnection.query(query, (err, res) => {
		if(err) {
		    reject(`Error querying CHP.user_: &{err}`);
		}
		ctx.body = res;
		ctx.status = 200;
		resolve();
	    });
	})
	    .catch(err => {
		ctx.status = 500;
		ctx.body = err;
	    });
    }

    // Returns a single, specified user
    async case(ctx) {
	console.log('Controller HIT: CaseController::case');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM case_ WHERE model = ? AND brand = ?;';
	    const brand = ctx.params.brand;
	    const model = ctx.params.model;
	    chpConnection.query ({
		sql: query,
		values: [model, brand]
	    }, (err, res) => {
		if(err) {
		    reject(err);
		}
		ctx.body = res;
		ctx.status = 200;
		resolve();
	    });
	})
	    .catch(err => {
		ctx.status = 500;
		ctx.body = {
		    error: `Internal Server Error: ${err}`,
		    status: 500
		};
	    });
    }

    // Adds a user to the database
    async addCase(ctx, next) {
	console.log('Controller HIT: CaseController::addCase');
	return new Promise((resolve, reject) => {
	    const newCS = ctx.request.body;
	    chpConnection.query ({
		sql: 'INSERT INTO case_ (model, brand, length, width, height, form_factor, gpu_clearance, rad_clearance, price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);',
		values: [newCS.model, newCS.brand, newCS.length, newCS.width, newCS.height, newCS.form_factor, newCS.gpu_clearance, newCS.rad_clearance, newCS.price]
	    }, (err, res) => {
		if(err) {
		    reject(err);
		}
		resolve();
	    });
	})
	    .then(await next)
	    .catch(err => {
		ctx.status = 500;
		ctx.body = {
		    error: `Internal Server Error: ${err}`,
		    status: 500

		};
	    });
    }

    // Update an existing server entry
    async updateCase(ctx, next) {
        console.log('Controller HIT: CaseController::updateCase');
        return new Promise((resolve, reject) => {
            const cs = ctx.request.body;
	    const brand = ctx.params.brand;
	    const model = ctx.params.model;
            chpConnection.query({
                sql: `
                    UPDATE case_ 
                    SET 
                        length = ?,
                        width = ?,
                        height = ?,
                        form_factor = ?,
                        gpu_clearance = ?,
                        rad_clearance = ?,
                        price = ?
                    WHERE model = ? AND brand = ?;
                    `,
                values: [cs.length, cs.width, cs.height, cs.form_factor, cs.gpu_clearance, cs.rad_clearance, cs.price, model, brand]
            }, (err, res) => {
                if(err) {
                    reject(err);
                }

                resolve();
            });
        })
         .then(await next)
         .catch(err => {
            ctx.status = 500;
            ctx.body = {
                error: `Internal Server Error: ${err}`,
                status: 500
            };
        });
    }

    // Deletes a user from the database
    async deleteCase(ctx, next) {
	console.log('Controller HIT: CaseController::deleteCase');
	return new Promise((resolve, reject) => {
	    const brand = ctx.params.brand;
	    const model = ctx.params.model;
	    chpConnection.query ({
		sql: `DELETE FROM case_ WHERE model = ? AND brand = ?;`,
		values: [model, brand]
	    }, (err, res) => {
		if(err) {
		    reject(err);
		}
		resolve();
	    });
	})
	    .then(await next)
	    .catch(err => {
		ctx.status = 500;
		ctx.body = {
		    error: `Internal Server Error: ${err}`,
		    status: 500
		};
	    });
    }
}

module.exports = CaseController;

const chpConnection = require('../database/CHPConnection');

class CoolerController {
    constructor() {
	console.log('Cooler Controller Initialized');
    }

    // Return all coolers
    async coolers(ctx) {
	console.log('Controller HIT: CoolerController::coolers');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM cooler_;';
	    chpConnection.query(query, (err, res) => {
		if(err) {
		    reject(`Error querying CHP.cooler_: &{err}`);
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

    // Returns a single, specified cooler
    async cooler(ctx) {
	console.log('Controller HIT: CoolerController::cooler');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM cooler_ WHERE model = ? AND brand = ?;';
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

    // Adds a cooler to the database
    async addCooler(ctx, next) {
	console.log('Controller HIT: CoolerController::addCooler');
	return new Promise((resolve, reject) => {
	    const newCLR = ctx.request.body;
	    chpConnection.query ({
		sql: 'INSERT INTO cooler_ (model, brand, type_, rad_size, power_draw, price) VALUES (?, ?, ?, ?, ?, ?);',
		values: [newCLR.model, newCLR.brand, newCLR.type_, newCLR.rad_size, newCLR.power_draw, newCLR.price]
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
    async updateCooler(ctx, next) {
        console.log('Controller HIT: CoolerController::updateCooler');
        return new Promise((resolve, reject) => {
            const clr = ctx.request.body;
	    const brand = ctx.params.brand;
	    const model = ctx.params.model;
            chpConnection.query({
                sql: `
                    UPDATE cooler_ 
                    SET 
                        type_ = ?,
                        rad_size = ?,
                        power_draw = ?,
                        price = ?
                    WHERE model = ? AND brand = ?
                    `,
                values: [clr.type_, clr.rad_size, clr.power_draw, clr.price, model, brand]
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
    async deleteCooler(ctx, next) {
	console.log('Controller HIT: CoolerController::deleteCooler');
	return new Promise((resolve, reject) => {
	    const brand = ctx.params.brand;
	    const model = ctx.params.model;
	    chpConnection.query ({
		sql: `DELETE FROM cooler_ WHERE model = ? AND brand = ?;`,
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

module.exports = CoolerController;

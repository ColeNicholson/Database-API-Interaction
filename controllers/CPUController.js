const chpConnection = require('../database/CHPConnection');

class CPUController {
    constructor() {
	console.log('CPU Controller Initialized');
    }

    // Return all users
    async cpus(ctx) {
	console.log('Controller HIT: CPUController::cpus');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM cpu_;';
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
    async cpu(ctx) {
	console.log('Controller HIT: CPUController::cpu');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM cpu_ WHERE model = ? AND brand = ?;';
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
    async addCPU(ctx, next) {
	console.log('Controller HIT: CPUController::addCPU');
	return new Promise((resolve, reject) => {
	    const newCPU = ctx.request.body;
	    chpConnection.query ({
		sql: 'INSERT INTO cpu_ (model, brand, socket_, frequency, SMT, cores, threads, max_memory, power_draw, price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);',
		values: [newCPU.model, newCPU.brand, newCPU.socket_, newCPU.frequency, newCPU.SMT, newCPU.cores, newCPU.threads, newCPU.max_memory, newCPU.power_draw, newCPU.price]
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
    async updateCPU(ctx, next) {
        console.log('Controller HIT: CPUController::updateCPU');
        return new Promise((resolve, reject) => {
            const cpu = ctx.request.body;
	    const brand = ctx.params.brand;
	    const model = ctx.params.model;
            chpConnection.query({
                sql: `
                    UPDATE cpu_ 
                    SET 
                        socket_ = ?,
                        frequency = ?,
                        SMT = ?,
                        cores = ?,
                        threads = ?,
                        max_memory = ?,
                        power_draw = ?,
                        price = ?
                    WHERE model = ? AND brand = ?
                    `,
                values: [cpu.socket_, cpu.frequency, cpu.SMT, cpu.cores, cpu.threads, cpu.max_memory, cpu.power_draw, cpu.price, model, brand]
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
    async deleteCPU(ctx, next) {
	console.log('Controller HIT: CPUController::deleteCPU');
	return new Promise((resolve, reject) => {
	    const brand = ctx.params.brand;
	    const model = ctx.params.model;
	    chpConnection.query ({
		sql: `DELETE FROM cpu_ WHERE model = ? AND brand = ?;`,
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

module.exports = CPUController;

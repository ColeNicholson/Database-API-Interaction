const chpConnection = require('../database/CHPConnection');

class BuildController {
    constructor() {
	console.log('Build Controller Initialized');
    }

    // Return all builds
    async builds(ctx) {
	console.log('Controller HIT: BuildController::builds');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM build_;';
	    chpConnection.query(query, (err, res) => {
		if(err) {
		    reject(`Error querying CHP.build_: &{err}`);
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

    // Returns the most expensive build in the data base, used for the default route
    async defaultBuild(ctx) {
	console.log('Controller HIT: BuildController::defaultBuild');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM most_expensive_build';
	    chpConnection.query(query, (err, res) => {
		if(err) {
		    reject(`Error querying CHP.build_: ${err}`);
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

    // Returns a single, specified build
    async build(ctx) {
	console.log('Controller HIT: BuildController::build');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM build_ WHERE bname = ? AND ID = ?;';
	    chpConnection.query ({
		sql: query,
		values: [ctx.params.bname, ctx.params.ID]
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
    async addBuild(ctx, next) {
	console.log('Controller HIT: BuildController::addBuild');
	return new Promise((resolve, reject) => {
	    const newBLD = ctx.request.body;
	    chpConnection.query ({
		sql: 'INSERT INTO build_ (bname, ID, motherboard_name, motherboard_brand, psu_name, psu_brand, psu_wattage, psu_efficiency, ram_name, ram_brand, ram_frequency, ram_capacity, ram_type, case_name, case_brand, cpu_name, cpu_brand, cooler_name, cooler_brand) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);',
		values: [newBLD.bname, newBLD.ID, newBLD.motherboard_name, newBLD.motherboard_brand, newBLD.psu_name, newBLD.psu_brand, newBLD.psu_wattage, newBLD.psu_efficiency, newBLD.ram_name, newBLD.ram_brand, newBLD.ram_frequency, newBLD.ram_capacity, newBLD.ram_type, newBLD.case_name, newBLD.case_brand, newBLD.cpu_name, newBLD.cpu_brand, newBLD.cooler_name, newBLD.cooler_brand]
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
    async updateBuild(ctx, next) {
        console.log('Controller HIT: BuildController::updateBuild');
        return new Promise((resolve, reject) => {
            const newBLD = ctx.request.body;
	    const bname = ctx.params.bname;
	    const ID = ctx.params.ID;
            chpConnection.query({
                sql: `
                    UPDATE build_ 
                    SET 
                        motherboard_name = ?, motherboard_brand = ?, psu_name = ?, psu_brand = ?, psu_wattage = ?, psu_efficiency = ?, ram_name = ?, ram_brand = ?, ram_frequency = ?, ram_capacity = ?, ram_type = ?, case_name = ?, case_brand = ?, cpu_name = ?, cpu_brand = ?, cooler_name = ?, cooler_brand = ? WHERE bname = ? AND ID = ?;`,
                values: [newBLD.motherboard_name, newBLD.motherboard_brand, newBLD.psu_name, newBLD.psu_brand, newBLD.psu_wattage, newBLD.psu_efficiency, newBLD.ram_name, newBLD.ram_brand, newBLD.ram_frequency, newBLD.ram_capacity, newBLD.ram_type, newBLD.case_name, newBLD.case_brand, newBLD.cooler_name, newBLD.cooler_brand, bname, ID]
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
    async deleteBuild(ctx, next) {
	console.log('Controller HIT: BuildController::deleteBuild');
	return new Promise((resolve, reject) => {
	    chpConnection.query ({
		sql: `DELETE FROM build_ WHERE bname = ? AND ID = ?;`,
		values: [ctx.params.bname, ctx.params.ID]
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

module.exports = BuildController;

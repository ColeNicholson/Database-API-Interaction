const chpConnection = require('../database/CHPConnection');

class CaseMotherboardSupportController {
    constructor() {
	console.log('Case-Motherboard Support Controller Initialized');
    }

    // Return all users
    async caseMotherboardSupports(ctx) {
	console.log('Controller HIT: CaseMotherboardSupportController::caseMotherboardSupports');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM case_motherboard_support_;';
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
    async caseMotherboardSupport(ctx) {
	console.log('Controller HIT: CaseMotherboardSupportController::caseMotherboardSupport');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM case_motherboard_support_ WHERE case_name = ? AND case_brand = ? AND motherboard_form_factor = ?;';
	    const cms = ctx.params.caseMotherboardSupport;
	    chpConnection.query ({
		sql: query,
		values: [cms]
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
    async addCaseMotherboardSupport(ctx, next) {
	console.log('Controller HIT: CaseMotherboardSupportController::addCaseMotherboardSupport');
	return new Promise((resolve, reject) => {
	    const newCMS = ctx.request.body;
	    chpConnection.query ({
		sql: 'INSERT INTO case_motherboard_support_ (case_name, case_brand, motherboard_form_factor) VALUES (?, ?, ?);',
		values: [newCMS.case_name. newCMS.case_brand, newCMS.motherboard_form_factor]
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
    // Functionally, this table really only serves to add or remove entries, never to update
    /*async updateCaseMotherboardSupport(ctx, next) {
        console.log('Controller HIT: UserController::updateUser');
        return new Promise((resolve, reject) => {
            const cms = ctx.request.body;
            chpConnection.query({
                sql: `
                    UPDATE case_motherboard_support_ 
                    SET 
                        case_name = ?,
                        case_brand = ?,
                        motherboard_form_factor = ?
                    WHERE ID = ?
                    `,
                values: [usr.email, usr.username, usr.fname, usr.lname, ctx.params.user]
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
    }*/

    // Deletes a user from the database
    async deleteCaseMotherboardSupport() {
	console.log('Controller HIT: CaseMotherboardSupportController::deleteCaseMotherboardSupport');
	return new Promise((resolve, reject) => {
	    chpConnection.query ({
		sql: `DELETE FROM case_motherboard_support_ WHERE case_name = ? AND case_brand = ? AND motherboard_form_factor = ?;`,
		values: [ctx.params.caseMotherboardSupport]
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

module.exports = CaseMotherboardSupportController;

const chpConnection = require('../database/CHPConnection');

class UserController {
    constructor() {
	console.log('User Controller Initialized');
    }

    // Return all users
    async users(ctx) {
	console.log('Controller HIT: UserController::users');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM user_;';
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
    async user(ctx) {
	console.log('Controller HIT: UserController::user');
	return new Promise((resolve, reject) => {
	    const query = 'SELECT * FROM user_ WHERE ID = ?;';
	    const usr = ctx.params.user;
	    chpConnection.query ({
		sql: query,
		values: [usr]
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
    async addUser(ctx, next) {
	console.log('Controller HIT: UserController::addUser');
	return new Promise((resolve, reject) => {
	    const newUSR = ctx.request.body;
	    chpConnection.query ({
		sql: 'INSERT INTO user_ (email, username, fname, lname) VALUES (?, ?, ?, ?);',
		values: [newUSR.email, newUSR.username, newUSR.fname, newUSR.lname]
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
    async updateUser(ctx, next) {
        console.log('Controller HIT: UserController::updateUser');
        return new Promise((resolve, reject) => {
            const usr = ctx.request.body;
            chpConnection.query({
                sql: `
                    UPDATE user_ 
                    SET 
                        email = ?,
                        username = ?,
                        fname = ?,
                        lname = ?
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
    }

    // Deletes a user from the database
    async deleteUser(ctx, next) {
	console.log('Controller HIT: UserController::deleteUser');
	return new Promise((resolve, reject) => {
	    chpConnection.query ({
		sql: `DELETE FROM user_ WHERE ID = ?;`,
		values: [ctx.params.user]
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

module.exports = UserController;

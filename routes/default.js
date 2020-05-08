const userRouter = require('./user');
const coolerRouter = require('./cooler');
const caseRouter = require('./case');
const buildRouter = require('./build');
const BuildController = require('../controllers/BuildController');
const cpuRouter = require('./cpu.js');
const defaultRouter = require('koa-router')({
    prefix: '/api'
});

// How to get defualt route to call defaultBuild in BuildController Class?
buildRouter.get('/', ctx => {
    ctx.status = 200;
    ctx.body = "Default route found!";
});

defaultRouter.use(
    userRouter.routes(),
    coolerRouter.routes(),
    caseRouter.routes(),
    buildRouter.routes(),
    cpuRouter.routes()
);

module.exports = api => {
    api.use(defaultRouter.routes());
};

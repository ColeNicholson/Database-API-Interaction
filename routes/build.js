const BuildController = new (require('../controllers/BuildController'))();
const buildRouter = require('koa-router')({
    prefix: '/build'
});


buildRouter.get('/', BuildController.builds);
buildRouter.get('/meb', BuildController.defaultBuild);
buildRouter.get('/:bname/:ID', BuildController.build);
buildRouter.post('/', BuildController.addBuild, BuildController.builds);
buildRouter.put('/:bname/:ID', BuildController.updateBuild, BuildController.build);
buildRouter.delete('/:bname/:ID', BuildController.deleteBuild, BuildController.builds);

module.exports = buildRouter;

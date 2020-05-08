const CaseController = new (require('../controllers/CaseController'))();
const caseRouter = require('koa-router')({
    prefix: '/case'
});


caseRouter.get('/', CaseController.cases);
caseRouter.get('/:brand/:model', CaseController.case);
caseRouter.post('/', CaseController.addCase, CaseController.cases);
caseRouter.put('/:brand/:model', CaseController.updateCase, CaseController.case);
caseRouter.delete('/:brand/:model', CaseController.deleteCase, CaseController.cases);

module.exports = caseRouter;

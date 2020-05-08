const CoolerController = new (require('../controllers/CoolerController'))();
const coolerRouter = require('koa-router')({
    prefix: '/cooler'
});


coolerRouter.get('/', CoolerController.coolers);
coolerRouter.get('/:brand/:model', CoolerController.cooler);
coolerRouter.post('/', CoolerController.addCooler, CoolerController.coolers);
coolerRouter.put('/:brand/:model', CoolerController.updateCooler, CoolerController.cooler);
coolerRouter.delete('/:brand/:model', CoolerController.deleteCooler, CoolerController.coolers);

module.exports = coolerRouter;

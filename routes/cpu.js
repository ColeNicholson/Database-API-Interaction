const CPUController = new (require('../controllers/CPUController'))();
const cpuRouter = require('koa-router')({
    prefix: '/cpu'
});


cpuRouter.get('/', CPUController.cpus);
cpuRouter.get('/:brand/:model', CPUController.cpu);
cpuRouter.post('/', CPUController.addCPU, CPUController.cpus);
cpuRouter.put('/:brand/:model', CPUController.updateCPU, CPUController.cpu);
cpuRouter.delete('/:brand/:model', CPUController.deleteCPU, CPUController.cpus);

module.exports = cpuRouter;

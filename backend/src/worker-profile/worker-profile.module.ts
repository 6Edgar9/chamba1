import { Module } from '@nestjs/common';
import { WorkerProfileService } from './worker-profile.service.js';
import { WorkerProfileController } from './worker-profile.controller.js';

@Module({
  controllers: [WorkerProfileController],
  providers: [WorkerProfileService],
  exports: [WorkerProfileService],
})
export class WorkerProfileModule {}

import { TestBed } from '@angular/core/testing';

import { ReturnvalueService } from './returnvalue.service';

describe('ReturnvalueService', () => {
  let service: ReturnvalueService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ReturnvalueService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});

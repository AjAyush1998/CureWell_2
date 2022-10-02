import { Component, OnInit } from '@angular/core';
import { Specialization } from '../../curewell-interfaces/specialization';
import { CurewellService } from '../../curewell-services/curewell.service';
import { Router, ActivatedRoute } from '@angular/router';
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Route } from '@angular/compiler/src/core';
import { Doctor } from '../../curewell-interfaces/doctor';

@Component({
 templateUrl: './view-specialization.component.html',
})
export class ViewSpecializationComponent implements OnInit {

  specializationList: Specialization[];
  showMsgDiv: boolean = false;
  errorMsg: string;

  constructor(private _curewellService: CurewellService, private router: Router) { }

  ngOnInit() {
    //To do implement necessary logic
    this.getSpecialization();
    if (this.specializationList == null) {
      this.showMsgDiv = true;
    }
  }

  getSpecialization() {
    //To do implement necessary logic
    this._curewellService.getAllSpecializations().subscribe(
      res => {
        this.specializationList = res;
        this.showMsgDiv = false;
      },
      re => {
        this.specializationList = re;
        this.errorMsg = re;
        this.showMsgDiv = true;
      },
      ()=> console.log("Specialization Fetched Successfully.")
    );
  }
}

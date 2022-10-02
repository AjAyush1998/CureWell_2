import { Component, OnInit } from '@angular/core';
import { Surgery } from '../../curewell-interfaces/surgery';
import { CurewellService } from '../../curewell-services/curewell.service';
import { Router, ActivatedRoute } from '@angular/router';
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Route } from '@angular/compiler/src/core';
import { error } from 'protractor';

@Component({
  templateUrl: './view-todays-surgery.component.html',
})
export class ViewTodaysSurgeryComponent implements OnInit {

  surgeryList: Surgery[];
  showMsgDiv: boolean = false;
  errorMsg: string;

  constructor(private _curewellService: CurewellService, private router: Router) { }

  ngOnInit() {
    //To do implement necessary logic
    this.getTodaySurgery();
    if (this.surgeryList == null) {
      this.showMsgDiv = true;
    }
  }

  getTodaySurgery() {
    //To do implement necessary logic
    this._curewellService.getAllSurgeriesForToday().subscribe(
      res => {
        this.surgeryList = res;
      },
      re => {
        this.surgeryList = null;
        this.errorMsg = re;
      },
      () => console.log("Today's Surgery Fetched Successfully")
    );
  }

  editSurgery(surgery: Surgery) {
    //To do implement necessary logic
    this.router.navigate(['/editSurgery', surgery.doctorId, surgery.endTime, surgery.startTime, surgery.surgeryCategory, surgery.surgeryDate, surgery.surgeryId]);
  }

}

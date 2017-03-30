import { Component, OnInit, AfterViewInit, OnDestroy, NgZone, ViewChild, Renderer, ElementRef } from '@angular/core';
import { Http, Response, RequestOptions } from '@angular/http';
import { Observable } from 'rxjs/Observable';
import { Router } from '@angular/router';
import 'fine-uploader';
import { AuthService } from '../services/auth.service';
import { Album } from '../model/album';
import { Photo, UpdPhoto } from '../model/photo';
import { LogLevel } from '../model/common';
import { environment } from '../../environments/environment';
import { MdSnackBar } from '@angular/material';

@Component({
  selector: 'acgallery-photoupload',
  templateUrl: './photoupload.component.html',
  styleUrls: ['./photoupload.component.css']
})
export class PhotouploadComponent implements OnInit, AfterViewInit, OnDestroy {
  public selectedFiles: any;
  public progressNum: number = 0;
  public isUploading: boolean = false;
  public photoMaxKBSize: number = 0;
  public photoMinKBSize: number = 0;
  public arUpdPhotos: UpdPhoto[] = [];
  private uploader: any = null;
  public assignAlbum: number = 0;
  private canCrtAlbum: boolean;
  private albumCreate: Album;
  @ViewChild('uploadFileRef') elemUploadFile;

  constructor(private _zone: NgZone,
    private _router: Router,
    private _authService: AuthService,
    private _elmRef: ElementRef,
    public _snackBar: MdSnackBar) {
    if (environment.LoggingLevel >= LogLevel.Debug) {
      console.log("ACGallery [Debug]: Entering onSubmit of PhotoUploadComponent");
    }

    this._authService.authContent.subscribe((x) => {
      if (x.canUploadPhoto()) {
        let sizes = x.getUserUploadKBSize();
        this.photoMinKBSize = sizes[0];
        this.photoMaxKBSize = sizes[1];
      } else {
        this.photoMinKBSize = 0;
        this.photoMaxKBSize = 0;
      }
    });
    this.canCrtAlbum = this._authService.authSubject.getValue().canCreateAlbum();
    this.albumCreate = new Album();
  }

  ngOnInit() {
    if (environment.LoggingLevel >= LogLevel.Debug) {
      console.log("ACGallery [Debug]: Entering ngOnInit of PhotoUploadComponent");
    }
  }

  ngAfterViewInit() {
    if (environment.LoggingLevel >= LogLevel.Debug) {
      console.log("ACGallery [Debug]: Entering ngAfterViewInit of PhotoUploadComponent");
    }

    let that = this;
    if (!this.uploader && that.elemUploadFile) {
      this.uploader = new qq.FineUploaderBasic({
        button: that.elemUploadFile.nativeElement,
        autoUpload: false,
        request: {
          endpoint: 'api/file',
          customHeaders: that.getcustomHeader()
        },
        validation: {
          allowedExtensions: ['jpeg', 'jpg', 'gif', 'png'],
          minSizeLimit: that.photoMinKBSize * 1024,
          sizeLimit: that.photoMaxKBSize * 1024
        },
        callbacks: {
          onComplete: function(id: number, name, responseJSON) {
            if (environment.LoggingLevel >= LogLevel.Debug) {
              console.log("Entering uploader_onComplete of PhotoUploadComponent upon ID: " + id.toString() + "; name: " + name);
            }
          },
          onAllComplete: function(succids, failids) {
            if (environment.LoggingLevel >= LogLevel.Debug) {
              console.log("Entering uploader_onAllComplete of uploader_onAllComplete with succids: " + succids.toString() + "; failids: " + failids.toString());
            }
          },
          onStatusChange: function(id: number, oldstatus, newstatus) {
            if (environment.LoggingLevel >= LogLevel.Debug) {
              console.log("Entering uploader_onStatusChange of PhotoUploadComponent upon ID: " + id.toString() + "; From " + oldstatus + " to " + newstatus);
            }

            if (newstatus === "rejected") {
              let errormsg = "File size must smaller than " + that.photoMaxKBSize + " and larger than " + that.photoMinKBSize;
              that._snackBar.open(errormsg);
            }
            //SUBMITTED
            //QUEUED
            //UPLOADING
            //UPLOAD_RETRYING
            //UPLOAD_FAILED
            //UPLOAD_SUCCESSFUL
            //CANCELED
            //REJECTED
            //DELETED
            //DELETING
            //DELETE_FAILED
            //PAUSED
          },
          onSubmit: function(id: number, name: string) {
            if (environment.LoggingLevel >= LogLevel.Debug) {
              console.log("ACGallery [Debug]: Entering uploader_onSubmit of PhotoUploadComponent upon ID: " + id.toString() + "; name: " + name);
            }
          },
          onSubmitted: function(id: number, name: string) {
            if (environment.LoggingLevel >= LogLevel.Debug) {
              console.log("ACGallery [Debug]: Entering uploader_onSubmitted of PhotoUploadComponent upon ID: " + id.toString() + "; name: " + name);
            }

            if (that.uploader) {
              var fObj = that.uploader.getFile(id);
              that.readImage(id, fObj, name, that.arUpdPhotos);
            } else {
              let errormsg = "Failed to process File " + name;
              that._snackBar.open(errormsg);
            }
          },
          onTotalProgress: function(totalUploadedBytes: number, totalBytes: number) {
            if (environment.LoggingLevel >= LogLevel.Debug) {
              console.log("ACGallery [Debug]: Entering uploader_onTotalProgress of PhotoUploadComponent with totalUploadedBytes: " + totalUploadedBytes.toString() + "; totalBytes: " + totalUploadedBytes.toString());
            }
          },
          onUpload: function(id: number, name: string) {
            if (environment.LoggingLevel >= LogLevel.Debug) {
              console.log("ACGallery [Debug]: Entering uploader_onUpload of PhotoUploadComponent upon ID: " + id.toString() + "; name: " + name);
            }
          },
          onValidate: function(data) {
            if (environment.LoggingLevel >= LogLevel.Debug) {
              console.log("ACGallery [Debug]: Entering uploader_onValidate of PhotoUploadComponent with data: " + data);
            }
          }
        }
      });
    }
  }

  ngOnDestroy() {
  }

  onSubmit($event): void {
    if (environment.LoggingLevel >= LogLevel.Debug) {
      console.log("Entering onSubmit of PhotoUploadComponent");
    }
  }

  getcustomHeader() {
    var obj = {
      Authorization: 'Bearer ' + this._authService.authSubject.getValue().getAccessToken()
    };
    return obj;
  }

  onAssignAblumClick(num: number | string) {
    this._zone.run(() => {
      this.assignAlbum = +num;
    });
  }

  isAssginToExistingAlbum(): boolean {
    return 1 === +this.assignAlbum;
  }

  isAssginToNewAlbum(): boolean {
    return 2 === +this.assignAlbum;
  }

  canUploadPhoto(): boolean {
    return this.photoMaxKBSize > 0;
  }

  canCreateAlbum(): boolean {
    return this.canCrtAlbum;
  }

  private readImage(fid: number, file, nname, arPhotos: UpdPhoto[]) {
    var reader = new FileReader();
    let that = this;

    reader.addEventListener("load", function () {
      var image = new Image();

      image.addEventListener("load", function () {
        let updPhoto: UpdPhoto = new UpdPhoto();
        updPhoto.ID = +fid;
        updPhoto.OrgName = file.name;
        updPhoto.Name = nname;
        updPhoto.Width = +image.width;
        updPhoto.Height = +image.height;
        updPhoto.Title = file.name;
        updPhoto.Desp = file.name;
        let size = Math.round(file.size / 1024);
        updPhoto.Size = size.toString() + 'KB';

        if (size >= that.photoMaxKBSize || size <= that.photoMinKBSize) {
          updPhoto.ValidInfo = "File " + updPhoto.Name + " with size (" + updPhoto.Size + ") which is larger than " + that.photoMaxKBSize + " or less than " + that.photoMinKBSize;
          updPhoto.IsValid = false;
        } else {
          updPhoto.IsValid = true;
        }

        arPhotos.push(updPhoto);
      });

      //var useBlob = false && window.URL;
      //image.src = useBlob ? window.URL.createObjectURL(file) : reader.result;
      //if (useBlob) {
      //    window.URL.revokeObjectURL(file); // Free memory
      //}
      image.src = reader.result;
    });

    reader.readAsDataURL(file);
  }
}

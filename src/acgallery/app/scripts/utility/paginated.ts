﻿//export class Paginated {
//    public _page: number = 0;
//    public _pagesCount: number = 0;
//    public _totalCount: number = 0;

//    constructor(page: number, pagesCount: number, totalCount: number) {
//        this._page = page;
//        this._pagesCount = pagesCount;
//        this._totalCount = totalCount;
//    }

//    range(): Array<any> {
//        if (!this._pagesCount) { return []; }
//        var step = 2;
//        var doubleStep = step * 2;
//        var start = Math.max(0, this._page - step);
//        var end = start + 1 + doubleStep;
//        if (end > this._pagesCount) { end = this._pagesCount; }

//        var ret = [];
//        for (var i = start; i != end; ++i) {
//            ret.push(i);
//        }

//        return ret;
//    };

//    pagePlus(count: number): number {
//        return + this._page + count;
//    }

//    search(i): void {
//        this._page = i;
//    };
//}

export class UIPagination {
    private _totalItems: number;
    private _currentPage: number;
    private _itemsPerPage: number;
    private _maxVisualPage: number;
    private _totalPages: number;
    public visPags: Array<number>;

    constructor(itemInPage: number = 20, vispage: number = 5) {
        this._itemsPerPage = itemInPage;
        this._maxVisualPage = vispage;

        this._totalItems = 0;
        this._currentPage = 0;
    }

    get currentPage(): number {
        return this._currentPage;
    }
    set currentPage(val: number) {
        if (this._currentPage !== val) {
            this._currentPage = val;

            this.workOut();
        }
    }

    get totalCount(): number {
        return this._totalItems;
    }
    set totalCount(val: number) {
        if (this._totalItems !== val) {
            this._totalItems = val;

            this.workOut();
        }
    }

    private workOut(): void {
        if (this._totalItems === 0) {
            this._totalPages = 0;

            this.visPags = [];
            return;
        }

        if (this._currentPage === 0)
            return;

        this._totalPages = Math.ceil(this._totalItems / this._itemsPerPage);
        this.visPags = [];

        let startPage = this.currentPage;
        if (this._totalPages - this.currentPage < this._maxVisualPage) {
            if (this._totalPages < this._maxVisualPage) {
                startPage = 1;
            } else {
                startPage = Math.min(this.currentPage, this._totalPages - this._maxVisualPage + 1);
            }
        }

        for (let idx = startPage; idx <= this._totalPages; idx++) {
            this.visPags.push(idx);
        }
    }

    get isFirstVisible(): boolean {
        return this.currentPage > 1;
    }
    get isLastVisible(): boolean {
        return this.currentPage < this._totalPages;
    }
    get isNextVisible(): boolean {
        return this.currentPage < this._totalPages;
    }
    get isPreviousVisible(): boolean {
        return this.currentPage > 1;
    }

    get nextAPIString(): string {
        if (this._currentPage === 0)
            return "";

        let skipamt = (this.currentPage - 1) * this._itemsPerPage;
        if (skipamt === 0)
            return "?top=" + this._itemsPerPage;

        return "?top=" + this._itemsPerPage + "&skip=" + skipamt;
    }
    get previousAPIString(): string {
        if (this._totalItems === 0 || this._currentPage < 2)
            return "";

        let skipamt = (this.currentPage - 2) * this._itemsPerPage;
        if (skipamt === 0)
            return "?top=" + this._itemsPerPage;

        return "?top=" + this._itemsPerPage + "&skip=" + skipamt;
    }
}
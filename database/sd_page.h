#ifndef SD_PAGE_H_
#define SD_PAGE_H_

/*
 * sophia database
 * sphia.org
 *
 * Copyright (c) Dmitry Simonenko
 * BSD License
*/

typedef struct sdpageheader sdpageheader;
typedef struct sdpage sdpage;

struct sdpageheader {
	uint32_t crc;
	uint32_t count;
	uint32_t size;
	uint16_t sizeblock;
	uint64_t lsnmin;
	uint64_t lsnmax;
} srpacked;

struct sdpage {
	sdpageheader *h;
};

static inline void
sd_pageinit(sdpage *p, sdpageheader *h) {
	p->h = h;
}

static inline sdv*
sd_pagev(sdpage *p, uint32_t pos) {
	assert(pos < p->h->count);
	return (sdv*)((char*)p->h + sizeof(sdpageheader) +
	              p->h->sizeblock * pos);
}

static inline void*
sd_pagevalue(sdpage *p, sdv *v) {
	assert((p->h->sizeblock * p->h->count) + v->valueoffset <= p->h->size);
	return (char*)((char*)p->h + sizeof(sdpageheader) +
	               p->h->sizeblock * p->h->count) + v->valueoffset;
}

static inline sdv*
sd_pagemin(sdpage *p) {
	return sd_pagev(p, 0);
}

static inline sdv*
sd_pagemax(sdpage *p) {
	return sd_pagev(p, p->h->count - 1);
}

#endif

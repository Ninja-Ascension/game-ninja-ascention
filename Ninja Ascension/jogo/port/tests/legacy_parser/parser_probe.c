/* Internal headless format probe. No replacement renderer or gameplay functions. */
#include <spine/spine.h>
#include <spine/extension.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <windows.h>
#include <dbghelp.h>
static LONG WINAPI report_exception(EXCEPTION_POINTERS* ex) {
    HANDLE process=GetCurrentProcess();STACKFRAME64 frame;CONTEXT context=*ex->ContextRecord;int i;
    memset(&frame,0,sizeof(frame));
    SymInitialize(process,NULL,TRUE);
    frame.AddrPC.Offset=context.Rip;frame.AddrFrame.Offset=context.Rbp;frame.AddrStack.Offset=context.Rsp;
    frame.AddrPC.Mode=frame.AddrFrame.Mode=frame.AddrStack.Mode=AddrModeFlat;
    fprintf(stderr,"NATIVE_EXCEPTION code=0x%08lx address=%p\n",ex->ExceptionRecord->ExceptionCode,ex->ExceptionRecord->ExceptionAddress);
    for(i=0;i<16;i++) {
        char storage[sizeof(SYMBOL_INFO)+256];SYMBOL_INFO* symbol=(SYMBOL_INFO*)storage;DWORD64 displacement=0;
        memset(storage,0,sizeof(storage));symbol->SizeOfStruct=sizeof(SYMBOL_INFO);symbol->MaxNameLen=255;
        if(SymFromAddr(process,frame.AddrPC.Offset,&displacement,symbol))fprintf(stderr,"  %s+0x%llx\n",symbol->Name,(unsigned long long)displacement);
        if(!StackWalk64(IMAGE_FILE_MACHINE_AMD64,process,GetCurrentThread(),&frame,&context,NULL,SymFunctionTableAccess64,SymGetModuleBase64,NULL))break;
    }
    fflush(stderr);return EXCEPTION_EXECUTE_HANDLER;
}
#endif
static int texture_errors;
static int texture_pages;
char* _spUtil_readFile(const char* path,int* length) {
    FILE* f=fopen(path,"rb");long size;char* data;
    if(!f)return NULL;
    if(fseek(f,0,SEEK_END)!=0 || (size=ftell(f))<0 || size>2147483646L){fclose(f);return NULL;}
    rewind(f);data=(char*)malloc((size_t)size+1);
    if(!data){fclose(f);return NULL;}
    if(fread(data,1,(size_t)size,f)!=(size_t)size){free(data);fclose(f);return NULL;}
    fclose(f);data[size]=0;*length=(int)size;return data;
}
static unsigned be32(const unsigned char* p){return ((unsigned)p[0]<<24)|((unsigned)p[1]<<16)|((unsigned)p[2]<<8)|p[3];}
void _spAtlasPage_createTexture(spAtlasPage* page,const char* path) {
    /* Parser-only adapter reads real PNG dimensions; no GPU texture is claimed. */
    int size=0;char* bytes=_spUtil_readFile(path,&size);texture_pages++;
    if(!bytes || size<24 || memcmp(bytes,"\x89PNG\r\n\x1a\n",8)!=0){texture_errors++;free(bytes);return;}
    page->width=(int)be32((unsigned char*)bytes+16);
    page->height=(int)be32((unsigned char*)bytes+20);
    free(bytes);
}
void _spAtlasPage_disposeTexture(spAtlasPage* page){(void)page; /* No GPU allocation in parser-only probe. */}
int main(int argc,char** argv) {
    spAtlas* atlas;spSkeletonJson* reader;spSkeletonData* data;int result=1;
    #ifdef _WIN32
    SetErrorMode(SEM_FAILCRITICALERRORS|SEM_NOGPFAULTERRORBOX);
    SetUnhandledExceptionFilter(report_exception);
    #endif
    if(argc!=3){fprintf(stderr,"usage: parser_probe skeleton.json atlas\n");return 2;}
    fprintf(stderr,"Loading original atlas\n");fflush(stderr);
    atlas=spAtlas_createFromFile(argv[2],NULL);
    if(!atlas || texture_errors){fprintf(stderr,"atlas/PNG validation failed\n");if(atlas)spAtlas_dispose(atlas);return 3;}
    fprintf(stderr,"Atlas pages loaded: %d; reading skeleton\n",texture_pages);fflush(stderr);
    reader=spSkeletonJson_create(atlas);
    data=spSkeletonJson_readSkeletonDataFile(reader,argv[1]);
    if(reader->error) {
        /* Old reference parser can return non-NULL even after an animation error. */
        fprintf(stderr,"LEGACY_PARSE_ERROR: %s\n",reader->error);
        return 4;
    }
    if(!data){fprintf(stderr,"legacy parse failed: %s\n",reader->error?reader->error:"unspecified");}
    else {
        printf("PARSED version=%s bones=%d slots=%d animations=%d pages=%d\n",
               data->version?data->version:"unknown",data->bonesCount,data->slotsCount,data->animationsCount,texture_pages);
        fflush(stdout);
        result=!(data->bonesCount>0 && data->animationsCount>0 && texture_pages==3);
        {int a,t;for(a=0;a<data->animationsCount;a++)for(t=0;t<data->animations[a]->timelinesCount;t++)
            if(!data->animations[a]->timelines[t]) {
                fprintf(stderr,"INCOMPLETE_LEGACY_PARSE animation=%s null_timeline=%d/%d\n",data->animations[a]->name,t,data->animations[a]->timelinesCount);
                /* Fail without passing incomplete structures into the unmodified legacy destructor. */
                return 4;
            }
        }
        spSkeletonData_dispose(data);
    }
    spSkeletonJson_dispose(reader);spAtlas_dispose(atlas);return result;
}

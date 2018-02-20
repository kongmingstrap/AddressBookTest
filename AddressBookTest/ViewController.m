//
//  ViewController.m
//  AddressBookTest
//
//  Created by Takaaki Tanaka on 2015/10/04.
//  Copyright © 2015年 Takaaki Tanaka. All rights reserved.
//


@import AddressBook;

#import "ViewController.h"

@interface ViewController ()

@end

static ABRecordRef GetGroupRecord(ABAddressBookRef addressBook) {
    NSNumber *groupId = @(100);
    if (groupId) {
        ABRecordRef groupRecord = ABAddressBookGetGroupWithRecordID(addressBook, groupId.intValue);
        if (!groupRecord) {
            return NULL;
        }
        ABRecordRef sourceRecord = ABGroupCopySource(groupRecord);
        if (!sourceRecord) {
            return NULL;
        } else {
            CFRelease(sourceRecord);
            return groupRecord;
        }
    } else {
        return NULL;
    }
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    {
        CFErrorRef cfError = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &cfError);
        
        
        NSString *name = @"Appleseed";
        CFArrayRef contacts = ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)name);
        
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        NSLog(@"%d", status);
        
        {
            CFErrorRef cfError = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &cfError);
        
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool inGranted, CFErrorRef inCfError) {
                NSLog(@"inGranted: %d", inGranted);
            });
        }
        
    CFErrorRef cfError = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &cfError);
    if (!addressBook) {
        NSError *error = (__bridge_transfer NSError *)cfError;
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    }
    
    ABRecordRef person = ABPersonCreate();
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)@"John", &cfError);
    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)@"Appleseed", &cfError);
        
        
        
        {
            CFErrorRef cfError = NULL;
            ABMultiValueIdentifier identifier;
            ABMultiValueRef multiTel = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            CFStringRef label1 = kABPersonPhoneMainLabel;
            NSString *value1 = @"012-345-6789";
            ABMultiValueAddValueAndLabel(multiTel, (__bridge CFTypeRef)(value1), label1, &identifier);
            CFStringRef label2 = kABPersonPhoneIPhoneLabel;
            NSString *value2 = @"111-222-3333";
            ABMultiValueAddValueAndLabel(multiTel, (__bridge CFTypeRef)(value2), label2, &identifier);
            
            ABRecordSetValue(person, kABPersonPhoneProperty, multiTel, &cfError);
            
            CFRelease(multiTel);
            
        }
        
        
    ABAddressBookAddRecord(addressBook, person, &cfError);
    ABAddressBookSave(addressBook, &cfError);
    }
    
    {
        CFErrorRef cfError = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &cfError);
        if (!addressBook) {
            NSError *error = (__bridge_transfer NSError *)cfError;
            NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
        }
        
        ABRecordRef person = ABPersonCreate();
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)@"John", &cfError);
        ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)@"Appleseed", &cfError);
        
        
        
        {
            NSNumber *recordIdNumber = @(100);
            
            int32_t recordId = (int32_t)recordIdNumber.intValue;
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordId);
            
            CFErrorRef cfError = NULL;
            ABMultiValueIdentifier identifier;
            ABMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            CFStringRef label = kABHomeLabel;
            NSString *value = @"johnny@example.com";
            ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(value), label, &identifier);
            
            ABRecordSetValue(person, kABPersonEmailProperty, multiEmail, &cfError);
            CFRelease(multiEmail);
            
            ABAddressBookSave(addressBook, &cfError);
        }
        
        {
            NSNumber *recordIdNumber = @(100);
            
            int32_t recordId = (int32_t)recordIdNumber.intValue;
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordId);
            
            CFErrorRef cfError = NULL;
            ABAddressBookRemoveRecord(addressBook, person, &cfError);

            ABAddressBookSave(addressBook, &cfError);

        }
    }
    
    {
        NSNumber *groupId = @(200);
        
        CFErrorRef cfError = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &cfError);
        
        ABRecordRef groupRecord = ABAddressBookGetGroupWithRecordID(addressBook, groupId.intValue);

        ABRecordRef sourceRecord = ABGroupCopySource(groupRecord);
        
        if (sourceRecord && groupRecord) {
            CFArrayRef members = ABGroupCopyArrayOfAllMembers(groupRecord);
            if (members) {
                CFIndex maxCount = CFArrayGetCount(members);
                for(CFIndex i = 0; i < maxCount; i++) {
                    
                    ABRecordRef person = CFArrayGetValueAtIndex(members, i);
        
    }
    
#if 0
    ABRecordRef groupRecord = GetGroupRecord(addressBook);
    if (!groupRecord) {
        NSString *groupName = @"test";
        CFArrayRef sources = ABAddressBookCopyArrayOfAllSources(addressBook);
        CFIndex sourceCount = CFArrayGetCount(sources);
        for (CFIndex i = 0 ; i < sourceCount; i++) {
            ABRecordRef currentSource = CFArrayGetValueAtIndex(sources, i);
            CFTypeRef sourceType = ABRecordCopyValue(currentSource, kABSourceTypeProperty);
            NSString *sourceName = (__bridge NSString *)ABRecordCopyValue(currentSource, kABSourceNameProperty);
            BOOL isMatch = kABSourceTypeLocal == [(__bridge NSNumber *)sourceType intValue] || ([(__bridge NSNumber *)sourceType intValue] == kABSourceTypeCardDAV && [[sourceName lowercaseString] isEqualToString:@"card"]);
            CFRelease(sourceType);
            if (isMatch) {
                ABRecordRef group = ABGroupCreateInSource(currentSource);
                ABRecordSetValue(group, kABGroupNameProperty,(__bridge CFStringRef)groupName, &cfError);
                if (cfError) {
                    if (CFEqual(CFErrorGetDomain(cfError), ABAddressBookErrorDomain) && (CFErrorGetCode(cfError) == kABOperationNotPermittedByUserError)) {
                        // Continue the process to delete all local contacts
                        NSLog(@"%s: %@", __PRETTY_FUNCTION__, CFErrorGetDomain(cfError));
                        CFRelease(cfError);
                        cfError = NULL;
                    } else {
                        NSError *error = (__bridge_transfer NSError *)cfError;
                        NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
                    }
                }
                
                
                
                ABAddressBookAddRecord(addressBook, group, &cfError);
                if (cfError) {
                    if (CFEqual(CFErrorGetDomain(cfError), ABAddressBookErrorDomain) && (CFErrorGetCode(cfError) == kABOperationNotPermittedByUserError)) {
                        // Continue the process to delete all local contacts
                        NSLog(@"%s: %@", __PRETTY_FUNCTION__, CFErrorGetDomain(cfError));
                        CFRelease(cfError);
                        cfError = NULL;
                    } else {
                        NSError *error = (__bridge_transfer NSError *)cfError;
                        NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
                    }
                }
                ABAddressBookSave(addressBook, &cfError);
                if (cfError) {
                    if (CFEqual(CFErrorGetDomain(cfError), ABAddressBookErrorDomain) && (CFErrorGetCode(cfError) == kABOperationNotPermittedByUserError)) {
                        // Continue the process to delete all local contacts
                        NSLog(@"%s: %@", __PRETTY_FUNCTION__, CFErrorGetDomain(cfError));
                        CFRelease(cfError);
                        cfError = NULL;
                    } else {
                        NSError *error = (__bridge_transfer NSError *)cfError;
                        NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
                    }
                }
                ABRecordID groupId = ABRecordGetRecordID(group);
                NSLog(@"%s: groupId: %d", __PRETTY_FUNCTION__, groupId);
                break;
            }
        }
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

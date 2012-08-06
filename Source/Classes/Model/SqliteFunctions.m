#import "SqliteFunctions.h"

#import "ESLocaleFactory.h"

#include <assert.h>

void ObjcFormatAnsiDateUsingLocale_int( sqlite3_context* ctx_, int argc_, sqlite3_value** argv_ )
{
    assert( ctx_ );
    
    @autoreleasepool 
    {
        if ( argc_ != 3 )
        {
            sqlite3_result_error( ctx_, "ObjcFormatAnsiDate - too few parameters", 1 );
            return;
        }
        else if ( NULL == argv_ )
        {
            sqlite3_result_error( ctx_, "ObjcFormatAnsiDate - invalid argv", 2 );
            return;
        }

        const unsigned char* rawFormat_ = sqlite3_value_text( argv_[0] );
        int64_t timestamp    = sqlite3_value_int64( argv_[1] );
        const unsigned char* rawLocaleIdentifier_ = sqlite3_value_text( argv_[2] );

        if ( NULL == rawFormat_ || NULL == rawLocaleIdentifier_ )
        {
            sqlite3_result_error( ctx_, "ObjcFormatAnsiDate - NULL argument passed", 3 );
            return;        
        }
        

        NSString* format_ = [ [ NSString alloc ] initWithBytesNoCopy: (void*)rawFormat_
                                                              length: strlen( (const char*)rawFormat_ )
                                                            encoding: NSUTF8StringEncoding
                                                        freeWhenDone: NO ];

        NSString* localeIdentifier_ = [ [ NSString alloc ] initWithBytesNoCopy: (void*)rawLocaleIdentifier_
                                                            length: strlen( (const char*)rawLocaleIdentifier_ )
                                                          encoding: NSUTF8StringEncoding
                                                      freeWhenDone: NO ];
        
        NSString* result_ = nil;
        NSArray* validlocaleIdentifiers_ = [ NSLocale availableLocaleIdentifiers ];
        if ( [ validlocaleIdentifiers_ containsObject: localeIdentifier_ ] )
        {
           
            NSDate* date_ = [NSDate dateWithTimeIntervalSince1970:timestamp];
            NSLocale* locale_ = [[ [ NSLocale alloc ] initWithLocaleIdentifier: localeIdentifier_ ] autorelease];
            
            
            NSDateFormatter* targetFormatter_ = [ ESLocaleFactory gregorianDateFormatterWithLocale: locale_ ];
            targetFormatter_.dateFormat = format_;
            
            
            result_ = [ targetFormatter_ stringFromDate: date_ ];
        }
        

        
        if ( nil == result_ || [ result_ isEqualToString: @"" ] )
        {    
            sqlite3_result_null( ctx_ );
        }
        else 
        {
            sqlite3_result_text
            ( 
                ctx_, 
                (const char*)[ result_ cStringUsingEncoding      : NSUTF8StringEncoding ], 
                (int        )[ result_ lengthOfBytesUsingEncoding: NSUTF8StringEncoding ], 
                SQLITE_TRANSIENT 
            );
        }
    }
}

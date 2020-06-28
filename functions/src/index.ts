import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands, CaptureRequestModel, CancelTransactionRequestModel} from 'cielo';

admin.initializeApp(functions.config().firebase);

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

const merchantId = functions.config().cielo.merchantid;
const merchantKey = functions.config().cielo.merchantkey;

const cieloParams: CieloConstructor = {
    merchantId: merchantId,
    merchantKey: merchantKey,
    sandbox: false,
    debug: false,
}

const cielo = new Cielo(cieloParams);

export const authorizeCreditCard = functions.https.onCall(async (data, context) => {
    if(data === null){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Dados não informados"
            }
        };
    }

    if(!context.auth){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Nenhum usuário logado"
            }
        };
    }

    const userId = context.auth.uid;

    const snapshot = await admin.firestore().collection("users").doc(userId).get();
    const userData = snapshot.data() || {};

    console.log("Iniciando Autorização");

    let brand: EnumBrands;
    switch(data.creditCard.brand){
        case "VISA":
            brand = EnumBrands.VISA;
            break;
        case "MASTERCARD":
            brand = EnumBrands.MASTER;
            break;
        case "AMEX":
            brand = EnumBrands.AMEX;
            break;
        case "ELO":
            brand = EnumBrands.ELO;
            break;
        case "JCB":
            brand = EnumBrands.JCB;
            break;
        case "DINERSCLUB":
            brand = EnumBrands.DINERS;
            break;
        case "DISCOVER":
            brand = EnumBrands.DISCOVERY;
            break;
        case "HIPERCARD":
            brand = EnumBrands.HIPERCARD;
            break;
        default:
            return {
                "success": false,
                "error": {
                    "code": -1,
                    "message": "Cartão não suportado: " + data.creditCard.brand
                }
            };
    }

    const saleData: TransactionCreditCardRequestModel = {
        merchantOrderId: data.merchantOrderId,
        customer: {
            name: userData.name,
            identity: data.cpf,
            identityType: 'CPF',
            email: userData.email,
            deliveryAddress: {
                street: userData.address.street,
                number: userData.address.number,
                complement: userData.address.complement,
                zipCode: userData.address.zipCode.replace('.', '').replace('-', ''),
                city: userData.address.city,
                state: userData.address.state,
                country: 'BRA',
                district: userData.address.district,
            }
        },
        payment: {
            currency: 'BRL',
            country: 'BRA',
            amount: data.amount,
            installments: data.installments,
            softDescriptor: data.softDescriptor.substring(0, 13),
            type: data.paymentType,
            capture: false,
            creditCard: {
                cardNumber: data.creditCard.cardNumber,
                holder: data.creditCard.holder,
                expirationDate: data.creditCard.expirationDate,
                securityCode: data.creditCard.securityCode,
                brand: brand
            }
        }
    }

    try {
        const transaction = await cielo.creditCard.transaction(saleData);

        if(transaction.payment.status === 1){
            return {
                "success": true,
                "paymentId": transaction.payment.paymentId
            }
        } else {
            let message = '';
            switch(transaction.payment.returnCode) {
                case '5':
                    message = 'Não Autorizada';
                    break;
                case '57':
                    message = 'Cartão expirado';
                    break;
                case '78':
                    message = 'Cartão bloqueado';
                    break;
                case '99':
                    message = 'Timeout';
                    break;
                case '77':
                    message = 'Cartão cancelado';
                    break;
                case '70':
                    message = 'Problemas com o Cartão de Crédito';
                    break;
                default:
                    message = transaction.payment.returnMessage;
                    break;
            }
            return {
                "success": false,
                "status": transaction.payment.status,
                "error": {
                    "code": transaction.payment.returnCode,
                    "message": message
                }
            }
        }
    } catch (error){
        console.log("Error ", error);
        return {
            "success": false,
            "error": {
                "code": error.respose[0].Code,
                "message": error.response[0].Message
            }
        };
    }

});

export const captureCreditCard = functions.https.onCall(async (data, context) => {
    if(data === null){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Dados não informados"
            }
        };
    }

    if(!context.auth){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Nenhum usuário logado"
            }
        };
    }

    const captureParams: CaptureRequestModel = {
        paymentId: data.payId,
    }

    try {
        const capture = await cielo.creditCard.captureSaleTransaction(captureParams);
        
        if(capture.status === 2){
            return {"success": true};
        } else {
            return {
                "success": false,
                "status": capture.status,
                "error": {
                    "code": capture.returnCode,
                    "message": capture.returnMessage,
                }
            };
        }
    } catch (error){
        console.log("Error ", error);
        return {
            "success": false,
            "error": {
                "code": error.respose[0].Code,
                "message": error.response[0].Message
            }
        };
    }

});

export const cancelCreditCard = functions.https.onCall(async (data, context) => {
    if(data === null){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Dados não informados"
            }
        };
    }

    if(!context.auth){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Nenhum usuário logado"
            }
        };
    }

    const cancelParams: CancelTransactionRequestModel = {
        paymentId: data.payId,
    }

    try {
        const cancel = await cielo.creditCard.cancelTransaction(cancelParams);
        
        if(cancel.status === 10 || cancel.status === 11){
            return {"success": true};
        } else {
            return {
                "success": false,
                "status": cancel.status,
                "error": {
                    "code": cancel.returnCode,
                    "message": cancel.returnMessage,
                }
            };
        }
    } catch (error){
        console.log("Error ", error);
        return {
            "success": false,
            "error": {
                "code": error.respose[0].Code,
                "message": error.response[0].Message
            }
        };
    }

});



export const helloWorld = functions.https.onCall((data, context) => {
  return {data: "Hellow from Cloud Functions!!!"};
});

export const getUserData = functions.https.onCall( async (data, context) => {
    if(!context.auth){
        return {
            "data": "Nenhum usuário logado"
        };
    }

    console.log(context.auth.uid);

    const snapshot = await admin.firestore().collection("users").doc(context.auth.uid).get();

    console.log(snapshot.data());

    return {
        "data": snapshot.data()
    };
});

export const addMessage = functions.https.onCall( async (data, context) => {
    console.log(data);

    const snapshot = await admin.firestore().collection("messages").add(data);

    return {"success": snapshot.id};
});

export const onNewOrder = functions.firestore.document("/orders/{orderId}").onCreate(async (snapshot, context) => {
    const orderId = context.params.orderId;
    
    const querySnapshot = await admin.firestore().collection("admins").get();

    const admins = querySnapshot.docs.map(doc => doc.id);

    let adminsTokens: string[] = [];
    for(let i = 0; i < admins.length; i++){
        const tokensAdmin: string[] = await getDeviceTokens(admins[i]);
        adminsTokens = adminsTokens.concat(tokensAdmin);
    }

    console.log(orderId, adminsTokens);

});

async function getDeviceTokens(uid: string){
    const querySnapshot = await admin.firestore().collection("users").doc(uid).collection("tokens").get();

    const tokens = querySnapshot.docs.map(doc => doc.id);

    return tokens;
}